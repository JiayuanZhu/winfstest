#!/usr/bin/python

# CreateFile FlagsAndAttributes
# DeleteFile

from winfstest import *

name = uniqname()

# Simulate Notepad++ write file 
# Create a new file, write 01 to it, read it back,
# open the file with CREATE_ALWAYS, write "0" to it, 
# file size should 1, read it back should only get "0"
# 1-8
expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("WriteFile %s 0 2 30 31 " % name, 0)
expect("ReadFile %s  0 2" % name, lambda r: r[0]["Data"] == "30 31")
expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("WriteFile %s 0 1 30 " % name, 0)
expect("GetFileInformation %s" % name, lambda r: r[0]["FileSize"] == 1)
expect("ReadFile %s  0 2" % name, lambda r: r[0]["Data"] == "30")
expect("DeleteFile %s" % name, 0)

# Simulate Copy & Paste a new file
# 9-15
expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("CreateFile %s GENERIC_WRITE 0 0 OPEN_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("SetEndOfFile %s 2" % name, 0)
expect("WriteFile %s 0 2 30 31 " % name, 0)
expect("GetFileInformation %s" % name, lambda r: r[0]["FileSize"] == 2)
expect("ReadFile %s  0 2" % name, lambda r: r[0]["Data"] == "30 31")
expect("DeleteFile %s" % name, 0)

#Simulate Copy & Paste overwrite an existing file
# 16-22
expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("SetEndOfFile %s 2" % name, 0)
expect("WriteFile %s 0 2 30 31 " % name, 0)
expect("GetFileInformation %s" % name, lambda r: r[0]["FileSize"] == 2)
expect("ReadFile %s  0 2" % name, lambda r: r[0]["Data"] == "30 31")
expect("DeleteFile %s" % name, 0)

# Simulate common software save a new file
# 23 - 36
expect("CreateFile %s GENERIC_WRITE 0 0 OPEN_EXISTING FILE_ATTRIBUTE_NORMAL 0" % name, "ERROR_FILE_NOT_FOUND")
expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("CreateFile %s GENERIC_WRITE 0 0 OPEN_EXISTING FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("DeleteFile %s" % name, 0)
expect("CreateFile %s GENERIC_WRITE 0 0 OPEN_EXISTING FILE_ATTRIBUTE_NORMAL 0" % name, "ERROR_FILE_NOT_FOUND")
expect("CreateFile %s GENERIC_WRITE 0 0 OPEN_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("CreateFile %s GENERIC_WRITE 0 0 OPEN_EXISTING FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("DeleteFile %s" % name, 0)
expect("CreateFile %s GENERIC_WRITE 0 0 OPEN_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("CreateFile %s GENERIC_WRITE 0 0 OPEN_EXISTING FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("WriteFile %s 0 2 30 31 " % name, 0)
expect("GetFileInformation %s" % name, lambda r: r[0]["FileSize"] == 2)
expect("ReadFile %s  0 2" % name, lambda r: r[0]["Data"] == "30 31")
expect("DeleteFile %s" % name, 0)

# Simulate common software save to an existing file
# 37 - 51
tmp_file_name = uniqname()
expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % tmp_file_name, 0)
expect("CreateFile %s GENERIC_WRITE 0 0 OPEN_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % tmp_file_name, 0)
with expect_task("CreateFile %s GENERIC_WRITE FILE_SHARE_READ+FILE_SHARE_WRITE 0 OPEN_EXISTING FILE_ATTRIBUTE_NORMAL 0" % tmp_file_name, 0):
    with expect_task("CreateFile %s GENERIC_READ FILE_SHARE_WRITE 0 OPEN_EXISTING FILE_ATTRIBUTE_NORMAL 0" % tmp_file_name, 0):
        expect("GetFileInformation %s" % tmp_file_name, lambda r: r[0]["FileSize"] == 0)
    expect("WriteFile %s 0 2 30 31 " % tmp_file_name, 0)
expect("CreateFile %s GENERIC_WRITE 0 0 OPEN_EXISTING FILE_ATTRIBUTE_NORMAL 0" % tmp_file_name, 0)
expect("MoveFileEx %s %s MOVEFILE_REPLACE_EXISTING" % (tmp_file_name, name), 0)
expect("CreateFile %s GENERIC_READ 0 0 OPEN_EXISTING FILE_ATTRIBUTE_NORMAL 0" % tmp_file_name, "ERROR_FILE_NOT_FOUND")
expect("CreateFile %s GENERIC_READ 0 0 OPEN_EXISTING FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("GetFileInformation %s" % name, lambda r: r[0]["FileSize"] == 2)
expect("ReadFile %s  0 2" % name, lambda r: r[0]["Data"] == "30 31")
expect("DeleteFile %s" % name, 0)
expect("DeleteFile %s" % tmp_file_name, "ERROR_FILE_NOT_FOUND")

testdone()
