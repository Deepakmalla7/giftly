import { Router } from 'express';
import { getProfile } from '../controllers/auth';
import { uploadProfilePhoto, deleteProfilePhoto } from '../controllers/user';
import { authenticateToken } from '../middleware/auth';
import { upload } from '../middleware/upload';

const router = Router();

// Routes
router.get('/profile', authenticateToken, getProfile);
router.post('/profile/photo', authenticateToken, upload.single('photo'), uploadProfilePhoto);
router.delete('/profile/photo', authenticateToken, deleteProfilePhoto);

export default router;