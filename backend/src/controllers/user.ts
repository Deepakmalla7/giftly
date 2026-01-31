import { Response } from 'express';
import { AuthRequest } from '../middleware/auth';
import User from '../models/User';
import path from 'path';
import fs from 'fs';

// ================= UPLOAD PROFILE PHOTO =================
export const uploadProfilePhoto = async (req: AuthRequest, res: Response) => {
  try {
    if (!req.user) {
      return res.status(401).json({ message: 'User not authenticated' });
    }

    if (!req.file) {
      return res.status(400).json({ message: 'No file uploaded' });
    }

    // Delete old photo if exists
    if (req.user.profilePhoto) {
      const oldPhotoPath = path.join(__dirname, '../../uploads', path.basename(req.user.profilePhoto));
      if (fs.existsSync(oldPhotoPath)) {
        fs.unlinkSync(oldPhotoPath);
      }
    }

    // Update user with new photo URL
    const photoUrl = `/uploads/${req.file.filename}`;
    req.user.profilePhoto = photoUrl;
    await req.user.save();

    res.json({
      message: 'Profile photo uploaded successfully',
      profilePhoto: photoUrl
    });
  } catch (error) {
    console.error('Upload photo error:', error);
    
    // Clean up uploaded file on error
    if (req.file) {
      const filePath = path.join(__dirname, '../../uploads', req.file.filename);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }
    }
    
    res.status(500).json({ message: 'Server error' });
  }
};

// ================= DELETE PROFILE PHOTO =================
export const deleteProfilePhoto = async (req: AuthRequest, res: Response) => {
  try {
    if (!req.user) {
      return res.status(401).json({ message: 'User not authenticated' });
    }

    if (!req.user.profilePhoto) {
      return res.status(404).json({ message: 'No profile photo to delete' });
    }

    // Delete the photo file
    const photoPath = path.join(__dirname, '../../uploads', path.basename(req.user.profilePhoto));
    if (fs.existsSync(photoPath)) {
      fs.unlinkSync(photoPath);
    }

    // Update user
    req.user.profilePhoto = undefined;
    await req.user.save();

    res.json({
      message: 'Profile photo deleted successfully'
    });
  } catch (error) {
    console.error('Delete photo error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
