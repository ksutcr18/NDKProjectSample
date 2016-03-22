# ����һ������Android.mk��д����

LOCAL_PATH := $(call my-dir)

# PRINT_TEST := 0
# PRINT_PATH := 0

#http://stackoverflow.com/questions/18136918/how-to-get-current-directory-of-your-makefile
#Code below will work for any for Makefiles invoked from any directory:

# https://www.gnu.org/software/make/manual/html_node/Text-Functions.html
# http://wiki.ubuntu.org.cn/index.php?title=%E8%B7%9F%E6%88%91%E4%B8%80%E8%B5%B7%E5%86%99Makefile:%E4%BD%BF%E7%94%A8%E5%87%BD%E6%95%B0&variant=zh-hans
# $(notdir <names...>)ȡ�ļ����� ���ļ�������<names>��ȡ����Ŀ¼���֡���Ŀ¼������ָ���һ����б�ܣ���/����֮��Ĳ��֡�
# $(patsubst <pattern>,<replacement>,<text>)ģʽ�ַ����滻����  
# $(strip <string>)ȥ�ո��� ȥ��<string>;�ִ��п�ͷ�ͽ�β�Ŀ��ַ���

#���ڱ�ʾ·�������֣���PATH��׺����������б�ܣ�DIR���������б��

mkfile_path := $(strip $(abspath $(lastword $(MAKEFILE_LIST)))) #ȡ����ǰmakefile��·���������Ǿ���·��
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path)))) #patsubstһ���ʾȥβ��б�ܣ�%�����ⳤ��ͨ���

TOP_ABS_DIR :=$(dir $(mkfile_path))
TOP_ABS_PATH :=$(patsubst %/,%,$(TOP_ABS_DIR)) #�������ӡ�н�β����ֿո񣬲���

ifeq ($(PRINT_PATH), 1)
 #print a info about the current dir, maybe a relative path, such as "jni"
 $(info [^-^] LOCAL_PATH = "$(LOCAL_PATH)")
 $(info [^-^] mkfile_path = "$(mkfile_path)") #���治֪Ϊ�ν�β���ո�strip����
 $(info [^-^] current_absolute_direcory_with_last_slash = "$(TOP_ABS_DIR)") # OK
 $(info [^-^] current_absolute_direcory_without_last_slash = "$(TOP_ABS_PATH)") #β�ո�
endif

ifdef USE_UNDISTRIBUTED
  UNDISTRIBUTED_C_INCLUDES := $(LOCAL_PATH)/undistributed/include
  UNDISTRIBUTED_LDLIBS := $(TOP_ABS_DIR)undistributed/lib/$(TARGET_ARCH)
  $(info ^-^ UNDISTRIBUTED_LDLIBS = $(UNDISTRIBUTED_LDLIBS))
endif

#################################################################
# xxModule                                                      
#################################################################

#include $(CLEAR_VARS)
#LOCAL_MODULE    := xx
#LOCAL_SRC_FILES := yy.c zz.c
#LOCAL_LDLIBS    := -llog -landroid
#include $(BUILD_EXECUTABLE)


#################################################################
# Include other Android.mk files                                
#################################################################

# Include makefiles here. Its important that these includes are 
# done after the main module, explanation below.

#ע�⣬�������mk�ļ�Ҳʹ��LOCAL_PATH���ǹ����
# create a temp variable with the current path, because it changes
# after each include
TOP_LOCAL_PATH := $(LOCAL_PATH)

#include $(TOP_LOCAL_PATH)/HelloWorld/Android.mk
#include $(TOP_LOCAL_PATH)/MessagePack/Android.mk
#include $(TOP_LOCAL_PATH)/toy/Android.mk

LOCAL_PATH = $(TOP_LOCAL_PATH) ## restore it

# I want only second-level mk files, that is the direct sub-directories
# in the current path.
include $(wildcard */*/Android.mk)
# include $(call all-subdir-makefiles)  ## $(wildcard $(call my-dir)/*/Android.mk)
# include $(call all-makefiles-under,$(LOCAL_PATH))

#################################################################
# print test (first, "cd project_path", then, "ndk-build")      
#################################################################

# I dunno why it's an empty result for $(call all-subdir-makefiles).
ifdef PRINT_TEST
  # $(info [^-^ print-test] all-subdir-makefiles = "$(call all-subdir-makefiles) ")
  $(info [print-test] "$(wildcard $(TOP_ABS_DIR)*/Android.mk)") # print: xx/project_path/jni/xxdir/Android.mk
  $(info [print-test] assert "jni/Android.mk" = "$(wildcard */Android.mk)") # print: jni/Android.mk
  $(info [print-test] $$(wildcard */*/Android.mk) = "$(wildcard */*/Android.mk)") # print: jni/xxdir/Android.mk
endif

#ifeq ($(TARGET_ARCH), arm)
#    LOCAL_CFLAGS += -DPACKED="__attribute__ ((packed))"
#else
#    LOCAL_CFLAGS += -DPACKED=""
#endif

## can we use shell ls?
# LOCAL_C_INCLUDES := F:\Android\android-ndk-r10\sources\cxx-stl\stlport
# LOCAL_C_INCLUDES += $(shell ls -FR $(LOCAL_C_INCLUDES) | grep $(LOCAL_PATH)/$ )
# LOCAL_C_INCLUDES := $(LOCAL_C_INCLUDES:$(LOCAL_PATH)/%:=$(LOCAL_PATH)/%)

# 
# �鿴�����ƵĿ�����
# arm-linux-readelf -d libc.so ��ӡDynamic section�����д���[NEEDED] Shared library��

# �鿴����
# readelf -s libcutils.so ��ӡSymbol table '.dynsym'��
# nm -D libcutils.so
# objdump -tT libcutils.so ��ӡSYMBOL TABLE��DYNAMIC SYMBOL TABLE
