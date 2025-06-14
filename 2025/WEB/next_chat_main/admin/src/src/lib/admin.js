const bcrypt = require("bcryptjs");
const fs = require("fs");
const path = require("path");
const { prisma } = require("./prisma.js");

const initAdmin = async () => {
  const adminPassword = process.env.ADMIN_PASSWORD;
  if (!adminPassword) {
    console.error("FATAL: ADMIN_PASSWORD is not set.");
    process.exit(1);
  }

  const existingAdmin = await prisma.user.findFirst({
    where: { name: "admin" }
  });

  if (existingAdmin) {
    console.log("Admin user already exists.");
    return;
  }

  const hashedPassword = await bcrypt.hash(adminPassword, 10);

  const admin = await prisma.user.create({
    data: {
      name: "admin",
      email: "admin@localhost.com",
      password: hashedPassword,
      role: "ADMIN",
    }
  });

  const targetDir = path.join(process.cwd(), 'uploads', admin.id);
  const flagSrc = path.join(process.cwd(), 'flag.png');
  const flagDest = path.join(targetDir, 'flag.png');

  if (!fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir);
  }

  fs.copyFileSync(flagSrc, flagDest);

  console.log("Admin user created and flag copied successfully.");
};

module.exports = { initAdmin };