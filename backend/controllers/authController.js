const User = require('../models/User'); 
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const generateToken = (id) => jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '7d' });

// REGISTER
exports.register = async (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }

    const user = await User.create({ name, email, password }); // pas besoin de hasher ici
    const token = generateToken(user._id);

    res.status(201).json({
      user: {
        name: user.name,
        email: user.email,
        password: user.password, // haché automatiquement par le modèle
      },
      token
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// LOGIN
exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ message: 'Invalid credentials: email not found' });
    }

    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      return res.status(401).json({ message: 'Invalid credentials: wrong password' });
    }

    const token = generateToken(user._id);

    res.status(200).json({
      user: {
        name: user.name,
        email: user.email,
        password: user.password
      },
      token
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
