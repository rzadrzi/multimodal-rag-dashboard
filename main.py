import os
from dotenv import load_dotenv
def main():
    print("Hello from filemanager-02!")


if __name__ == "__main__":
    main()
    load_dotenv()

    print(os.getenv("DJANGO_SECRET_KEY"))
