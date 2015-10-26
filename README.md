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

include $(call all-makefiles-under,$(LOCAL_PATH)) ��$(LOCAL_PATH)ָ��Ŀ¼����������Ŀ¼��Android.mk  
include $(call all-subdir-under) �Ե�ǰĿ¼������һ����Ŀ¼Android.mk�����û�����Ƶݹ��﷨��  

[Դ��](http://androidxref.com/4.2_r1/xref/ndk/build/core/definitions.mk)
```mk
# -----------------------------------------------------------------------------
# Macro    : my-dir
# Returns  : the directory of the current Makefile
# Usage    : $(my-dir)
# -----------------------------------------------------------------------------
my-dir = $(call parent-dir,$(lastword $(MAKEFILE_LIST)))

# -----------------------------------------------------------------------------
# Function : all-makefiles-under
# Arguments: 1: directory path
# Returns  : a list of all makefiles immediately below some directory
# Usage    : $(call all-makefiles-under, <some path>)
# -----------------------------------------------------------------------------
all-makefiles-under = $(wildcard $1/*/Android.mk)

# -----------------------------------------------------------------------------
# Macro    : all-subdir-makefiles
# Returns  : list of all makefiles in subdirectories of the current Makefile's
#            location
# Usage    : $(all-subdir-makefiles)
# -----------------------------------------------------------------------------
all-subdir-makefiles = $(call all-makefiles-under,$(call my-dir))
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


#NDK

##Android NDK ��������ʹ�÷�����Standalone Toolchain��
[����](http://blog.csdn.net/smfwuxiao/article/details/6587709)

������Ҫȷ��Ŀ�������ָ���

����� x86 �Ļ������� x86-4.4.3 �汾�Ĺ������������ arm ָ��ģ��� arm-linux-androideabi-4.4.3 �汾 (x86-4.4.3 �� arm-linux-androideabi-4.4.3 λ��ndkĿ¼��)

1��gcc��sysroot ѡ��

sysrootѡ���趨 gcc �ڱ���Դ���ʱ��Ѱ��ͷ�ļ��Ϳ��ļ��ĸ�Ŀ¼�������������� gcc --sysroot=/tmp/gcc-arm (������ѡ��)��NDK ��Ŀ¼�µ� platforms Ŀ¼�еĸ�����Ŀ¼��·��������ֱ�Ӵ��� gcc --sysroot=<dir>��Ϊ�˼򻯲�����������linuxϵͳ�������ն�ִ�������������SYSROOT����������$NDK��ndk�ĸ�Ŀ¼��

$ SYSROOT=$NDK/platforms/android-8/arch-arm

2������ NDK gcc����1�ַ�������
 
����SYSROOT֮��Ҫ�������� gcc ��--sysrootѡ�����unix/linux�Դ���gcc���ǽ�����빤�ߣ���������Ҫʹ�õ���ndk���ṩ�Ľ�����빤�ߣ�Ҳ��gcc����������Ҫ��취�ñ���ű��ҵ�ndk�е�gcc������ҪȥѰ��ϵͳ�е�gcc���� unix/linux ϵͳ�ı���ű��������� CC �������������ñ�����������ͨ���� CC����Ϊndk�е�gcc��·�������ܰ�������ű��ҵ���ȷ��gcc�����ǻ���˳�����--sysrootѡ���

��CC ����������

$ export CC="$NDK/toolchains/<name>/prebuilt/<host-system>/bin/<prefix>gcc --sysroot=$SYSROOT"  
$ $CC -o foo.o -c foo.c  (����ִ����һ�У����������ǵ���gcc�������

�����1��֮��֮����ȥִ��./configure �Ϳ��Ա����arm�����ˡ���������Ҫ���ǹ������������⣬Ҫȷ���ó���û������ndkδ�ṩ�Ĺ���⡣�÷�����ȱ�ݾ��ǣ�����ʹ�� C++ STL��STLport �� GNU libstdc++ ����Ҳ����ʹ���쳣���ƺ�RTTI��

### ����NDK����������2�ַ��������򵥣�

1. ����������  
android ndk�ṩ�ű��������Լ�����һ�׹����������磺

$NDK/build/tools/make-standalone-toolchain.sh --platform=android-5 --install-dir=/tmp/my-android-toolchain [ --arch=x86 ]

������/tmp/my-android-toolchain �д��� sysroot ������ ��������--arch ѡ��ѡ��Ŀ������ָ��ܹ���Ĭ����Ϊ arm��
������� --install-dir ѡ���ᴴ�� /tmp/ndk/<toolchain-name>.tar.bz2��

2. ���û�������  
��������make-standalone-toolchain.sh�����������֮���٣�
```shell
$ export PATH=/tmp/my-android-toolchain/bin:$PATH
$ export CC=arm-linux-androideabi-gcc
$ export CXX=arm-linux-androideabi-g++
$ export CXXFLAGS="-lstdc++"
```

3. ʹ��make  
ִ�����������û�������������֮�󣬾Ϳ���ֱ�ӱ����ˣ����磬ִ�� ./configure Ȼ�� make �õ��ľ��� arm �����ˣ����������趨 sysroot, CC �ˡ����ң�����ʹ�� STL���쳣��RTTI��

4. make-standalone-toolchain.sh --help �鿴����  
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

* NDK�Դ�������

���磬android-ndk-r10�Դ��Ĺ���������������F:\Android\android-ndk-r10\toolchainsĿ¼�£�
```shell
fangss@fangss-PC ~
$ ll /cygdrive/f/Android/android-ndk-r10/toolchains
total 0
d---------+ 1 fangss None 0 Dec  9  2014 arm-linux-androideabi-4.6
d---------+ 1 fangss None 0 Dec  9  2014 arm-linux-androideabi-4.8
d---------+ 1 fangss None 0 Dec  9  2014 arm-linux-androideabi-clang3.3
d---------+ 1 fangss None 0 Dec  9  2014 arm-linux-androideabi-clang3.4
d---------+ 1 fangss None 0 Dec  9  2014 llvm-3.3
d---------+ 1 fangss None 0 Dec  9  2014 llvm-3.4
d---------+ 1 fangss None 0 Dec  9  2014 mipsel-linux-android-4.6
d---------+ 1 fangss None 0 Dec  9  2014 mipsel-linux-android-4.8
d---------+ 1 fangss None 0 Dec  9  2014 mipsel-linux-android-clang3.3
d---------+ 1 fangss None 0 Dec  9  2014 mipsel-linux-android-clang3.4
d---------+ 1 fangss None 0 Dec  9  2014 renderscript
d---------+ 1 fangss None 0 Dec  9  2014 x86-4.6
d---------+ 1 fangss None 0 Dec  9  2014 x86-4.8
d---------+ 1 fangss None 0 Dec  9  2014 x86-clang3.3
d---------+ 1 fangss None 0 Dec  9  2014 x86-clang3.4
```
[OUTPUT TRUNCATED]

* ����

���������Լ���������Cygwin��ִ��make-standalone-toolchain.sh�������������Ȩ�����⣬�����Ҽ�����Ա�������Cygwin��
```shell
fangss@fangss-PC ~
$ /cygdrive/f/Android/android-ndk-r10/build/tools/make-standalone-toolchain.sh --platform=android-9  --install-dir=/cygdrive/f/Android/android-ndk-r10/toolchains/my-arm-linux-androideabi
Auto-config: --toolchain=arm-linux-androideabi-4.6
Copying prebuilt binaries...
find: '/tmp/ndk-fangss/tmp/build-8324/standalone/arm-linux-androideabi-4.6/arm-linux-androideabi': Permission denied
find: '/tmp/ndk-fangss/tmp/build-8324/standalone/arm-linux-androideabi-4.6/bin': Permission denied
find: '/tmp/ndk-fangss/tmp/build-8324/standalone/arm-linux-androideabi-4.6/lib': Permission denied
find: '/tmp/ndk-fangss/tmp/build-8324/standalone/arm-linux-androideabi-4.6/libexec': Permission denied
find: '/tmp/ndk-fangss/tmp/build-8324/standalone/arm-linux-androideabi-4.6/share': Permission denied
mkdir: cannot create directory '/tmp/ndk-fangss/tmp/build-8324/standalone/arm-linux-androideabi-4.6/lib': Permission denied
ERROR: Cannot copy to directory: /tmp/ndk-fangss/tmp/build-8324/standalone/arm-linux-androideabi-4.6/lib/python2.7
```
��ȷ��������������my-arm-linux-androideabi�ļ��кܴ�
```shell
$ /cygdrive/f/Android/android-ndk-r10/build/tools/make-standalone-toolchain.sh --platform=android-9  --install-dir=/cygdrive/f/Android/android-ndk-r10/toolchains/my-arm-linux-androideabi
Auto-config: --toolchain=arm-linux-androideabi-4.6
Copying prebuilt binaries...
Copying sysroot headers and libraries...
Copying c++ runtime headers and libraries...
Copying files to: /cygdrive/f/Android/android-ndk-r10/toolchains/
Cleaning up...
Done.
```
���У����ɵ�һЩ�ļ���

* add2line������Ҫ�ҵĵ�ַת���ļ����кţ���Ҫʹ�� debug ��Ϣ��
* ar      ���������޸ĺͽ⿪һ���浵�ļ�
* as      ��gnu�Ļ����
* c++filt ��C++ �� java ����һ�����غ��������õ����غ������ᱻ����ת���ɻ��ı꣬c++filt ����ʵ�����ַ����ת�������ݱ�ŵõ���������
* gprof   ��gnu �����Ԥ��������
* ld      ��gnu ��������
* nm      ���г�Ŀ���ļ��ķ��źͶ�Ӧ�ĵ�ַ
* objcopy ����ĳ�ָ�ʽ��Ŀ���ļ�ת���������ʽ��Ŀ���ļ�
* objdump ����ʾĿ���ļ�����Ϣ
* ranlib  ��Ϊһ���浵�ļ�����һ�����������������������浵�ļ���
* readelf ����ʾ elf ��ʽ��Ŀ���ļ�����Ϣ
* size    ����ʾĿ���ļ������ڵĴ�С��Ŀ���ļ��Ĵ�С
* strings ����ӡ��Ŀ���ļ��п��Դ�ӡ���ַ������и�Ĭ�ϵĳ��ȣ�Ϊ4
* strip   ������Ŀ���ļ������еķ�����Ϣ


����stripʹ���������£�

������tcpdumpʱ���ļ����ܱȽϴ󣬿���ʹ��strip��ȥ�����ţ��ɼ������40%��
�ο�(Monitoring Android Network Traffic Part II: Cross Compiling TCPDUMP)[http://www.symantec.com/connect/blogs/monitoring-android-network-traffic-part-ii-cross-compiling-tcpdump]
(-fPIE -pie����tcpdump)[http://www.liudonghua.com/?p=372]

```shell
mkdir ~/tcpdump
cd ~/tcpdump
wget http://www.tcpdump.org/release/libpcap-1.6.2.tar.gz
wget http://www.tcpdump.org/release/tcpdump-4.6.2.tar.gz
tar -xzvf libpcap-1.6.2.tar.gz
tar -xzvf tcpdump-4.6.2.tar.gz
mkdir toolchain
%NDK_HOME%/build/tools/make-standalone-toolchain.sh --platform=android-21 --install-dir=~/tcpdump/toolchain
export PATH=~/tcpdump/toolchain/bin:$PATH
export CC=arm-linux-androideabi-gcc
export RANLIB=arm-linux-androideabi-ranlib
export AR=arm-linux-androideabi-ar
export LD=arm-linux-androideabi-ld
cd libpcap-1.6.2
./configure --host=arm-linux --with-pcap=~/tcpdump/libpcap-1.6.2 ac_cv_linux_vers=2
make
cd ../tcpdump-4.6.2
sed -i".bak" "s/setprotoent/\/\/setprotoent/g" print-isakmp.c
sed -i".bak" "s/endprotoent/\/\/endprotoent/g" print-isakmp.c
./configure --host=arm-linux --with-pcap=linux --with-crypto=no ac_cv_linux_vers=2 --disable-ipv6
vi Makefile # ��CFLAGS��LDFLAGS�����"-fPIE -pie"
make # ���߲�����������һ����ʹ��make CFLAGS="-DNBBY=8 -fPIE -pie"
# ��������֮���ڸ�Ŀ¼�¼���tcpdump
file tcpdump
tcpdump: ELF 32-bit LSB  shared object, ARM, EABI5 version 1 (SYSV), dynamically linked (uses shared libs), not stripped
```
��Ӧ��strip����
```shell
root@debian $ ls -lh tcpdump
-rwx------ 1 root root 2.8M Aug 18 20:49 tcpdump
root@debian $ arm-linux-gnueabi-strip tcpdump
root@debian $ ls -lh tcpdump
-rwx------ 1 root root 1.5M Aug 18 20:50 tcpdump
```

֮��Ϳ���ʹ���ˣ������������»���

```shell
export PATH=/cygdrive/f/Android/android-ndk-r10/toolchains/my-arm-linux-androideabi/bin:$PATH
export CC=arm-linux-androideabi-gcc
export RANLIB=arm-linux-androideabi-ranlib
export AR=arm-linux-androideabi-ar
export LD=arm-linux-androideabi-ld
```

�پ��ǿ��Ա���������⣬��libpcap
```shell
cd libpcap-1.7.4
./configure --host=arm-linux --with-pcap=~/tcpdump/libpcap-1.7.4 ac_cv_linux_vers=2
make
```

## ���� & ����

5.1 Windows֧��
Windows�ϵ�NDK������������Cygwin��������Щ���߲������Cygwin��·���������磬/cygdrive/c/foo/bar����ֻ�����C:/cygdrive/c/foo/bar����·����������NDK �ṩ��build�����ܹ��ܺõ�Ӧ���������⣨ndk-build����

5.2 wchar_t ֧��  
wchar_t  ���ͽ��� Android 2.3 ��ʼ֧�֡��� android-9 �ϣ� wchar_t �� 4�ֽڡ� ���� C���Կ��ṩ֧�ֿ��ַ��ĺ��������⣺multi-byte ����/���� ���� �� wsprintf/wsscanf ����android-9 ��ǰ��ƽ̨�ϣ�wchar_t ��1�ֽڣ����ҿ��ַ������������á����鲻ʹ�� wchar_t���ṩ wchar_t ֧����Ϊ�˷�����ֲ��ǰ�Ĵ��롣

5.3 �쳣�� RTTI �� STL  
NDK ������Ĭ��֧��C++�쳣��RTTI��Run Time Type Information���������� -fno-exception �� -fno-rtti �رգ����ɵĻ������С��
ע�⣺ ���Ҫ�����������ԣ���Ҫ��ʽ���� libsupc++�����磺 arm-linux-androideabi-g++ .... -lsupc++ 
NDK �ṩ�� libstdc++����������� STL������Ҫ��ʽ���� libstdc++ ( gcc ... -lstdc++)�������ڽ������Բ����ֶ�ָ��������Ӳ�����
