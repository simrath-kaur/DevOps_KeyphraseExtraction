import requests
import re
import sys

def extract_confirm_code(file_id):
    # Make a GET request to obtain the confirmation code
    response = requests.get(f"https://docs.google.com/uc?export=download&id={file_id}")
    
    # Print the response text for debugging
    print(response.text)

    # Check if the response contains the confirmation code
    match = re.search(r"confirm=([a-zA-Z0-9-_]+)", response.text)
    if match:
        # Extract and return the confirmation code
        return match.group(1)
    else:
        # If no confirmation code found, return None
        return None

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
