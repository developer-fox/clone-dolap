from services.local_db_service import localDbInstance 
from dotenv import load_dotenv
load_dotenv(".env")
from actions.default_lifecycle import DefaultLifeCycle
from actions.initialization_actions import InitializationActions

def main():
  isInitialized = localDbInstance.getValueFromConfigWithKey("is_initialized")
  if(isInitialized is None):
    InitializationActions()

  localDbInstance.allUsersLogout()
  while True:
    currentCycyle =  DefaultLifeCycle(usersCount= 40)
    del currentCycyle

main()

