
import services.request_service as request_service
from services.local_db_service import localDbInstance
from model.user_model import UserModel
import services.file_service as file_service



def changeProfilePhoto(user: UserModel):
  requestResult = request_service.changeProfilePhoto(user)
  if(requestResult):
    file_service.deleteUserProfileImageFromLocale(user.imagePath)
  else:
    print("not success")