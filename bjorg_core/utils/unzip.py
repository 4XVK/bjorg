import sys
import zipfile

if len(sys.argv) > 1:
    with zipfile.ZipFile(sys.argv[1], "r") as z:
        z.extractall("")
else:
    print("Please provide path to archive...")
