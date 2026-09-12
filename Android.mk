LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),spinel)
include $(call all-makefiles-under,$(LOCAL_PATH))
endifLOCAL_PATH := $(call my-dir)
