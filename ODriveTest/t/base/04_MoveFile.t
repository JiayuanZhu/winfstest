#!/usr/bin/python

# MoveFileEx

from winfstest import *

name = uniqname()

expect("CreateDirectory %s 0" % name, 0)
expect("CreateFile %s\\foo GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("CreateFile %s\\baz GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("MoveFileEx %s\\foo %s\\bar 0" % (name, name), 0)
expect("GetFileInformation %s\\foo" % name, "ERROR_FILE_NOT_FOUND")
expect("GetFileInformation %s\\bar" % name, 0)
expect("MoveFileEx %s\\bar %s\\baz 0" % (name, name), "ERROR_ALREADY_EXISTS")
expect("GetFileInformation %s\\bar" % name, 0)
expect("GetFileInformation %s\\baz" % name, 0)
#expect("MoveFileEx %s\\bar %s\\baz MOVEFILE_REPLACE_EXISTING" % (name, name), "ERROR_ACCESS_DENIED")
#expect("SetFileAttributes %s\\baz FILE_ATTRIBUTE_NORMAL" % name, 0)
expect("MoveFileEx %s\\bar %s\\baz MOVEFILE_REPLACE_EXISTING" % (name, name), 0)
expect("GetFileInformation %s\\bar" % name, "ERROR_FILE_NOT_FOUND")
expect("GetFileInformation %s\\baz" % name, 0)
expect("DeleteFile %s\\baz" % name, 0)
expect("RemoveDirectory %s" % name, 0)

expect("CreateDirectory %s 0" % name, 0)
expect("CreateDirectory %s\\foo 0" % name, 0)
expect("CreateDirectory %s\\baz 0" % name, 0)
expect("MoveFileEx %s\\foo %s\\bar 0" % (name, name), 0)
expect("GetFileInformation %s\\foo" % name, "ERROR_FILE_NOT_FOUND")
expect("GetFileInformation %s\\bar" % name, 0)
expect("MoveFileEx %s\\bar %s\\baz 0" % (name, name), "ERROR_ALREADY_EXISTS")
expect("GetFileInformation %s\\bar" % name, 0)
expect("GetFileInformation %s\\baz" % name, 0)
expect("MoveFileEx %s\\bar %s\\baz MOVEFILE_REPLACE_EXISTING" % (name, name), "ERROR_ACCESS_DENIED")
expect("GetFileInformation %s\\bar" % name, 0)
expect("GetFileInformation %s\\baz" % name, 0)
expect("RemoveDirectory %s\\baz" % name, 0)
expect("MoveFileEx %s\\bar %s\\baz MOVEFILE_REPLACE_EXISTING" % (name, name), 0)
expect("GetFileInformation %s\\bar" % name, "ERROR_FILE_NOT_FOUND")
expect("GetFileInformation %s\\baz" % name, 0)
expect("RemoveDirectory %s\\baz" % name, 0)
expect("RemoveDirectory %s" % name, 0)

expect("CreateDirectory %s 0" % name, 0)
expect("CreateDirectory %s\\foo 0" % name, 0)
expect("CreateDirectory %s\\bar 0" % name, 0)
expect("CreateFile %s\\foo\\hello GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("MoveFileEx %s\\foo\\hello %s\\bar\\world 0" % (name, name), 0)
expect("GetFileInformation %s\\foo\\hello" % name, "ERROR_FILE_NOT_FOUND")
expect("GetFileInformation %s\\bar\\world" % name, 0)
expect("DeleteFile %s\\bar\\world" % name, 0)
expect("RemoveDirectory %s\\bar" % name, 0)
expect("RemoveDirectory %s\\foo" % name, 0)
expect("RemoveDirectory %s" % name, 0)

testdone()
