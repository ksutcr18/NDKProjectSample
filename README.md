# NDK Project

�ο�NDK����native-activity�����бȽϼ򵥵Ĺ��̽ṹ������cygwin��ndk-build����IDE����Ҳ������ΪAndroid���̵��루ʹ��IDE��

1. copy android-ndk-r10/samples/native-activity and remove or replace main.c, to get a ndk project
2. code and modify Android.mk to your module, note APP_ABI armeabi-v7a x86 (Application.mk)

3. $ ndk-build NDK_PROJECT_PATH=/cygdrive/f/Android/android-ndk-r10/samples/z_ndk_workspace/messagepack
4. $ adb push 'F:\Android\android-ndk-r10\samples\z_ndk_workspace\messagepack\libs\armeabi-v7a\cmp_unpack' /data/local/tmp
5. $ adb shell chmod 6755 /data/local/tmp/cmp_unpack
6. $ adb shell a /data/local/tmp/cmp_unpack
7. OK.

$ ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk

NDK_PROJECT_PATH ָ������Ҫ����Ĵ���Ĺ���Ŀ¼������������ǵ�ǰĿ¼��APP_BUILD_SCRIPT��������Android makefile�ļ���·������Ȼ������㻹�� Application.mk �ļ��Ļ����������� NDK_APP_APPLICATION_MK=./Application.mk 


# a ndk-build problem
* question
```
$ ndk-build
Android NDK: Could not find application project directory !    
Android NDK: Please define the NDK_PROJECT_PATH variable to point to it.    
/opt/android-ndk-r10b/build/core/build-local.mk:148: *** Android NDK: Aborting    .  Stop.
```
* answer
```
You need to specify 3 things.
NDK_PROJECT_PATH - the location of your project
NDK_APPLICATION_MK - the path of the Application.mk file
APP_BUILD_SCRIPT - the path to the Android.mk file

These are needed to override the default values of the build script, which expects things to be in the jni folder.

When calling ndk-build use
ndk-build NDK_PROJECT_PATH=/path/to/proj NDK_APPLICATION_MK=/path/to/Application.mk

In Application.mk add
APP_BUILD_SCRIPT := /path/to/Android.mk
```

VistualGDB

#VS+VA

(�ο�)[http://bbs.pediy.com/showthread.php?p=1353066]

��VS2008���½�Makefile��Ŀ

����������

��NDK��Ŀ¼����%PATH%��������������ֱ��ʹ������ndk-build��

����Ŀ������д��������

* Build command line: ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk
* Clean commands: ndk-build clean NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk
* Rebuild command line: ndk-build -B NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk
* Include search path: E:\Android\android-ndk-r9d\platforms\android-12\arch-arm\usr\include // ��Ӧ���㱾����Ŀ¼���汾��
�����ɡ�

#ʹ��makefile�Ŀ�

һ��Androidдc/c++��NDKʹ��Android.mk����ʹ��������Դ��ʱ�������ͨ��Makefile����ģ����ֿ�����ʹ��������Դ�⣬�����дAndroid.mk����鷳����ȻһЩ������AOSP�п����ҵ�����Щ��ʵ��toolchain�йء��ʿ��Զ�����һ��toolchain��ֱ��ʹ��Makefile��������Ҫ�Լ�ȥ���±�дAndroid.mk�ļ��������˺ܶ��鷳��

��Android NDK�ж���toolchain���裨ϵͳΪUbuntu(32λ)����

����Android NDK
����toolchain

��NDKѹ������ѹ��ϵͳ����/mntĿ¼�£�����/mntĿ¼�½����ļ���my_ndk_toolchain��Ȼ����/mntĿ¼��ִ���������

/mnt/android-ndk-r9c/build/tools/make-standalone-toolchain.sh --platform=android-19 --toolchain=arm-linux-androideabi-4.8 --stl=stlport --install-dir=/mnt/my_ndk_toolchain

�������´�ӡ��

dir=/mnt/my_ndk_toolchain  
Copying prebuilt binaries...  
Copying sysroot headers and libraries...  
Copying libstdc++ headers and libraries...  
Copying files to: /mnt/my_ndk_toolchain  
Cleaning up...  
Done.  

˵�������Ĺ������ɹ�����ִ�е�������м�˵����

* /mnt/android-ndk-r9c/build/tools/make-standalone-toolchain.sh��ִ��NDKĿ¼��make-standalone-toolchain.sh�ű���
* --platform��ָ��������ʹ���ĸ��汾��Android API����cd /mnt/android-ndk-r9c/platform�в鿴��������ʹ�õ���Android-19��
* --toolchain:ָ���������Ĺ�����������;�ı��룬arm(arm-linux-androideabi-4.8),X86(x86-4.8)��MIPS(mipsel-linux-android-4.8)����cd toolchains�в鿴��ѡ���ʺϵ����ͣ�������ʹ�õ���Ƕ��ʽ��
* --stl:ָ������֧��C++ stl��stlport����C++�⽫��̬���ӣ�stlport_shared����̬���ӣ�
* --install-dir:ָ��װĿ¼��

ע�⣺��Ϊ��ʹ�õ���32-bit Ubuntu������������Ĭ����32λ�������ڲ�����û��ָ��ϵͳ���ͣ������64-bit Linuxϵͳ�������--system=linux-x86_64 ��MacOSX����--system=darwin-x86_64��


3�����Գ���
```c++
hello.cpp
#include <iostream>
#include <string>
int main(int argc, char **argv)
{
    std::string str = "hello, ndk! this is my own toolchain! ^-^";
    std::cout << str << std::endl;
    return 0;
}
```
Makefile
```makefile
rm=/bin/rm -f
CC=/mnt/my_ndk_toolchain/bin/arm-linux-androideabi-g++
PROGNAME = main
INCLUDES= -I.
CFLAGS  = $(INCLUDES) -g -fPIC -D_FILE_OFFSET_BITS=64 -D_LARGE_FILE
OBJS   = hello.o
LDFLAGS =
all :$(PROGNAME)
%.o: %.cpp
        $(CC) $(CFLAGS) -c -o $@ $<
$(PROGNAME) : $(OBJS)
        @echo  "Linking $(PROGNAME)......"
        ${CC} ${LDFLAGS} -o ${PROGNAME} ${OBJS}
        @echo  "Linking Success!"
clean:
        $(rm) *.o  $(PROGNAME)
```
�����õ���ִ���ļ�:main��adb push��Ƕ��ʽAndroidƽ̨��./main���У��õ����½����
```shell
root@android :/data # ./main                                                
hello, ndk! this is my own toolchain! ^-^
```


#NDK������

## ����������

android ndk�ṩ�ű��������Լ�����һ�׹����������磺

$NDK/build/tools/make-standalone-toolchain.sh --platform=android-5 --install-dir=/tmp/my-android-toolchain [ --arch=x86 ]

������/tmp/my-android-toolchain �д��� sysroot ������ ��������--arch ѡ��ѡ��Ŀ������ָ��ܹ���Ĭ����Ϊ arm��
������� --install-dir ѡ���ᴴ�� /tmp/ndk/<toolchain-name>.tar.bz2��

## ���û�������

��������make-standalone-toolchain.sh�����������֮���٣�
```shell
$ export PATH=/tmp/my-android-toolchain/bin:$PATH
$ export CC=arm-linux-androideabi-gcc
$ export CXX=arm-linux-androideabi-g++
$ export CXXFLAGS="-lstdc++"
```

##ʹ��make

ִ�����������û�������������֮�󣬾Ϳ���ֱ�ӱ����ˣ����磬ִ�� ./configure Ȼ�� make �õ��ľ��� arm �����ˣ����������趨 sysroot, CC �ˡ����ң�����ʹ�� STL���쳣��RTTI��


## make-standalone-toolchain.sh --help �鿴����
```shell
$ /cygdrive/f/Android/android-ndk-r10/build/tools/make-standalone-toolchain.sh --help

Usage: make-standalone-toolchain.sh [options]

Generate a customized Android toolchain installation that includes
a working sysroot. The result is something that can more easily be
used as a standalone cross-compiler, e.g. to run configure and
make scripts.

Valid options (defaults are in brackets):

  --help                   Print this help.
  --verbose                Enable verbose mode.
  --toolchain=<name>       Specify toolchain name
  --llvm-version=<ver>     Specify LLVM version
  --stl=<name>             Specify C++ STL [gnustl]
  --arch=<name>            Specify target architecture
  --abis=<list>            Specify list of target ABIs.
  --ndk-dir=<path>         Take source files from NDK at <path> [/cygdrive/f/Android/android-ndk-r10]
  --system=<name>          Specify host system [windows]
  --package-dir=<path>     Place package file in <path> [/tmp/ndk-fangss]
  --install-dir=<path>     Don't create package, install files to <path> instead.
  --platform=<name>        Specify target Android platform/API level. [android-3]
```

## Windows֧��
Windows�ϵ�NDK������������ Cygwin��������Щ���߲������Cygwin��·���������磬/cygdrive/c/foo/bar����ֻ�����C:/cygdrive/c/foo/bar����·����������NDK �ṩ��build�����ܹ��ܺõ�Ӧ���������⣨ndk-build����

