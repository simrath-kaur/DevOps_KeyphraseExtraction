import requests
import re
import sys
from bs4 import BeautifulSoup

def extract_confirm_code(file_id):
    # Make a GET request to obtain the confirmation code
    response = requests.get(f"https://docs.google.com/uc?export=download&id={file_id}")
    
    # Check if the response contains a virus scan warning
    if "Google Drive - Virus scan warning" in response.text:
        # Extract download link and confirmation parameters
        soup = BeautifulSoup(response.text, 'html.parser')
        confirm_param = soup.find('input', {'name': 'confirm'}).get('value')
        id_param = soup.find('input', {'name': 'id'}).get('value')
        uuid_param = soup.find('input', {'name': 'uuid'}).get('value')
        return confirm_param, id_param, uuid_param
    else:
        # If no virus scan warning, return None
        return None, None, None

def main():
    file_id = sys.argv[1]
    file_name = sys.argv[2]
    confirm_code, file_id, uuid = extract_confirm_code(file_id)
    
    if confirm_code:
        # If confirmation required, make another request with confirmation parameters
        download_url = f"https://drive.google.com/uc?export=download&confirm={confirm_code}&id={file_id}&uuid={uuid}"
        response = requests.get(download_url)
        with open(file_name, "wb") as file:
            file.write(response.content)
    else:
        # If no confirmation required, download directly
        download_url = f"https://docs.google.com/uc?export=download&id={file_id}"
        response = requests.get(download_url)
        with open(file_name, "wb") as file:
            file.write(response.content)

if __name__ == "__main__":
    main()
