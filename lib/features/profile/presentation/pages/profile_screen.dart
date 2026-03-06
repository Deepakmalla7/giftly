import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giftly/core/models/user.dart';
import 'package:giftly/core/providers/service_providers.dart';
import 'package:giftly/features/dashboard/presentation/pages/login_screen.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  User? _currentUser;
  bool _isLoading = false;
  bool _isFetching = false;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isEditing = false;
  bool _isUpdating = false;
  bool _hasChanges = false;
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _setupFieldListeners();
    _loadCurrentUser();
  }

  void _setupFieldListeners() {
    _firstNameController.addListener(_updateHasChanges);
    _lastNameController.addListener(_updateHasChanges);
    _usernameController.addListener(_updateHasChanges);
  }

  void _populateControllers(User user) {
    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _usernameController.text = user.username ?? '';
    _emailController.text = user.email;
    _updateHasChanges();
  }

  void _updateHasChanges() {
    if (!_isEditing || _currentUser == null) {
      if (_hasChanges) {
        setState(() {
          _hasChanges = false;
        });
      }
      return;
    }

    final user = _currentUser!;
    final hasChanged =
        _selectedImage != null ||
        _firstNameController.text.trim() != (user.firstName ?? '').trim() ||
        _lastNameController.text.trim() != (user.lastName ?? '').trim() ||
        _usernameController.text.trim() != (user.username ?? '').trim();

    if (hasChanged != _hasChanges) {
      setState(() {
        _hasChanges = hasChanged;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not available';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[date.month - 1];
    return '$month ${date.day}, ${date.year}';
  }

  void _loadCurrentUser() async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      if (mounted) {
        setState(() {
          _isFetching = true;
        });
      }
      // Get local user first to get the ID
      final localUser = authRepository.getCurrentUser();
      if (localUser != null) {
        setState(() {
          _currentUser = localUser;
        });
        if (mounted && _currentUser != null) {
          _populateControllers(_currentUser!);
        }
      }

      // Try to fetch latest profile from server using local user ID
      if (localUser?.id != null && localUser!.id!.isNotEmpty) {
        try {
          final profile = await authRepository.getProfile(
            userId: localUser.id!,
          );
          if (mounted) {
            setState(() {
              _currentUser = User.fromJson(
                profile['user'] ?? profile['data'] ?? profile,
              );
            });
            if (_currentUser != null) {
              _populateControllers(_currentUser!);
            }
          }
        } catch (e) {
          // Silent fail - use local user
          print('Failed to fetch remote profile: $e');
        }
      }
    } catch (e) {
      print('Failed to load current user: $e');
      if (mounted) {
        setState(() {
          _currentUser = null;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFetching = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _startEditing() {
    if (_currentUser == null) return;
    setState(() {
      _populateControllers(_currentUser!);
      _isEditing = true;
    });
    _updateHasChanges();
  }

  void _cancelEditing() {
    setState(() {
      if (_currentUser != null) {
        _populateControllers(_currentUser!);
      }
      _selectedImage = null;
      _isEditing = false;
      _hasChanges = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState == null) return;
    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final updatedUser = await authRepository.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        username: _usernameController.text.trim(),
        imagePath: _selectedImage?.path,
      );

      if (mounted) {
        setState(() {
          _currentUser = updatedUser;
          _isEditing = false;
          _selectedImage = null;
          _hasChanges = false;
        });
        if (_currentUser != null) {
          _populateControllers(_currentUser!);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;
      if (mounted) {
        setState(() {
          _selectedImage = image;
        });
        _updateHasChanges();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick photo: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildEditableCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Editable Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              if (_isEditing)
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter your first name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'First name is required';
                    }
                    if (trimmed.length < 2) {
                      return 'First name must be at least 2 characters';
                    }
                    return null;
                  },
                )
              else
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person),
                  title: const Text('First Name'),
                  subtitle: Text(_currentUser!.firstName ?? '-'),
                ),
              const Divider(),
              if (_isEditing)
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Enter your last name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'Last name is required';
                    }
                    if (trimmed.length < 2) {
                      return 'Last name must be at least 2 characters';
                    }
                    return null;
                  },
                )
              else
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Last Name'),
                  subtitle: Text(_currentUser!.lastName ?? '-'),
                ),
              const Divider(),
              if (_isEditing)
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Choose a username',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'Username is required';
                    }
                    if (trimmed.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                )
              else
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.alternate_email),
                  title: const Text('Username'),
                  subtitle: Text(_currentUser!.username ?? '-'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyCard() {
    final accountStatus = _currentUser!.accountStatus ?? 'active';
    final role = _currentUser!.role ?? 'user';
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(_currentUser!.email),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.badge),
              title: const Text('Role'),
              subtitle: Text(role),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.verified_user),
              title: const Text('Account Status'),
              subtitle: Text(accountStatus),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: const Text('Account Created'),
              subtitle: Text(_formatDate(_currentUser!.createdAt)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch connection status
    final connectionStatus = ref.watch(connectionStatusProvider);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF0A2463),
      ),
      body: _isFetching
          ? const Center(child: CircularProgressIndicator())
          : _currentUser == null
          ? const Center(child: Text('No user logged in'))
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 720;
                final canSave = _isEditing && _hasChanges && !_isUpdating;
                final ImageProvider<Object>? profileImageProvider =
                    _selectedImage != null
                    ? FileImage(File(_selectedImage!.path))
                    : (_currentUser!.profilePictureUrl != null
                          ? NetworkImage(_currentUser!.profilePictureUrl!)
                          : null);

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    16 + mediaQuery.viewInsets.bottom,
                  ),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          connectionStatus.when(
                            data: (isConnected) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isConnected
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                                  border: Border.all(
                                    color: isConnected
                                        ? Colors.green
                                        : Colors.red,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isConnected
                                          ? Icons.cloud_done
                                          : Icons.cloud_off,
                                      color: isConnected
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isConnected ? 'Online' : 'Offline',
                                      style: TextStyle(
                                        color: isConnected
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            loading: () => Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Checking connection...'),
                                ],
                              ),
                            ),
                            error: (_, __) => Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text(
                                'Connection check failed',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 52,
                                    backgroundColor: const Color(0xFF0A2463),
                                    backgroundImage: profileImageProvider,
                                    child: profileImageProvider == null
                                        ? Text(
                                            _currentUser!.displayName.isNotEmpty
                                                ? _currentUser!.displayName[0]
                                                      .toUpperCase()
                                                : 'U',
                                            style: const TextStyle(
                                              fontSize: 36,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _currentUser!.displayName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _currentUser!.role ?? 'User',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  if (_isEditing)
                                    OutlinedButton.icon(
                                      onPressed: _pickProfileImage,
                                      icon: const Icon(Icons.photo_camera),
                                      label: Text(
                                        _selectedImage == null
                                            ? 'Change Photo'
                                            : 'Change Selected Photo',
                                      ),
                                    )
                                  else
                                    TextButton.icon(
                                      onPressed: _isUpdating
                                          ? null
                                          : _startEditing,
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Edit Profile'),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (isWide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildEditableCard()),
                                const SizedBox(width: 16),
                                Expanded(child: _buildReadOnlyCard()),
                              ],
                            )
                          else ...[
                            _buildEditableCard(),
                            const SizedBox(height: 16),
                            _buildReadOnlyCard(),
                          ],
                          const SizedBox(height: 16),
                          if (_isEditing)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: _isUpdating
                                      ? null
                                      : _cancelEditing,
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: canSave ? _saveProfile : null,
                                  child: _isUpdating
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text('Save Changes'),
                                ),
                              ],
                            ),
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _logout,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.logout),
                            label: Text(
                              _isLoading ? 'Logging out...' : 'Logout',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
