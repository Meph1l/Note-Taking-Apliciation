import folderDAO from "../dao/folderdao.js";

// Get all folders for a specific user
const getFoldersByUser = async (userId) => {
  return await folderDAO.getFoldersByUserId(userId);
};

// Get one folder by id
const getFolderById = async (folderId, userId) => {
  return await folderDAO.getFolderById(folderId, userId);
};

// Create a folder
const createFolder = async (folderName, userId, parentFolderId = null) => {
  if (parentFolderId !== null) {
    const parentFolder = await folderDAO.getFolderById(parentFolderId, userId);

    if (!parentFolder) {
      throw new Error("Parent folder not found.");
    }
  }

  // Check duplicate folder name under same parent
  const existingFolder = await folderDAO.findFolderByNameAndParent(
    folderName,
    userId,
    parentFolderId
  );

  if (existingFolder) {
    throw new Error("A folder with that name already exists.");
  }

  return await folderDAO.createFolder(folderName, userId, parentFolderId);
};

// Rename folder
const renameFolder = async (folderId, folderName, userId) => {
  const existingFolder = await folderDAO.getFolderById(folderId, userId);

  if (!existingFolder) {
    throw new Error("Folder not found.");
  }

  await folderDAO.renameFolder(folderId, folderName, userId);
  return true;
};

// Delete folder
const deleteFolder = async (folderId, userId) => {
  const existingFolder = await folderDAO.getFolderById(folderId, userId);

  if (!existingFolder) {
    throw new Error("Folder not found.");
  }

  // Delete the folder itself
  await folderDAO.deleteFolder(folderId, userId);

  return true;
};

export {
  getFoldersByUser,
  getFolderById,
  createFolder,
  renameFolder,
  deleteFolder
};