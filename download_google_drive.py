import requests
import re
import sys

def extract_confirm_code(file_id):
    url = f"https://docs.google.com/uc?export=download&id={file_id}"
    response = requests.get(url)
    confirm_code = re.search(r"confirm=([a-zA-Z0-9-_]+)", response.text).group(1)
    return confirm_code

def main():
    file_id = sys.argv[1]
    file_name = sys.argv[2]
    confirm_code = extract_confirm_code(file_id)
    download_url = f"https://docs.google.com/uc?export=download&confirm={confirm_code}&id={file_id}"
    response = requests.get(download_url)
    with open(file_name, "wb") as file:
        file.write(response.content)

if __name__ == "__main__":
    main()
