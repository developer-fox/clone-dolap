
import shutil
import os

def writeUserProfileImage(filename,response):
  try:
    with open(filename,"wb") as file: 
      shutil.copyfileobj(response.raw, file)
    return True
  except Exception as error:
    return False


def writeSingleNoticeImage(filename,response):
  try:
    with open(filename,"wb") as file: 
      shutil.copyfileobj(response.raw, file)
    return True
  except Exception as error:
    return False

def deleteUserProfileImageFromLocale(filename):
  if(os.path.exists(filename)):
    os.remove(filename)

def deleteCreatedNoticePhotosFromLocale(filePaths):
  for filePath in filePaths:
    if(os.path.exists(filePath)):
      os.remove(filePath)