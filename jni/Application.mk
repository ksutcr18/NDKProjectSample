#Application.mkĿ�������������Ӧ�ó���������Ҫ��ģ��(����̬���̬��)��
#Application.mk�ļ�ͨ���������� $PROJECT/jni/Application.mk�£�$PROJECTָ����������Ŀ��

#APP_BUILD_SCRIPT := Android.mk
APP_PLATFORM := android-10
APP_ABI = armeabi armeabi-v7a x86  # APP_ABI := all

# APP_STL := stlport_static

# Enable c++11 extentions in source code for all
# http://stackoverflow.com/questions/15616254/enable-c11-support-on-android
# http://stackoverflow.com/questions/17142759/latest-c11-features-with-android-ndk/19874831#19874831
# https://vilimpoc.org/blog/2013/10/05/c11-support-on-android-with-g-4-8/
# APP_CPPFLAGS += -std=c++11
# APP_CPPFLAGS := -std=gnu++11

# APP_PROJECT_PATH���������ǿ���Եģ����һ����Ӧ�ó��򹤳̵ĸ�Ŀ¼��һ������·����
# �����������ƻ��߰�װһ��û���κΰ汾���Ƶ�JNI�⣬�Ӷ���APK���ɹ���һ����ϸ��·����

#APP_PIE := false

# APP_PLATFORM �������˼����˵,ʹ�õ�Native API Version����Ͱ汾Java APIҪ��,���ܵ��µ��������:
# ��Native Code��ʹ����һ��platforms/android-14�µ�API����,Ȼ������� android-8 ����
# ��������,��Ȼ���������android-8�豸���ǲ����ڵ�,�ͻ������

#APP_ABI������ܹ���so�ļ��������apk�У����һ�����ϵͳCPU�ܹ����а�װ���������ַ�����
#����1������Application.mk�ļ������ڸ��ļ���ӣ�APP_ABI := armeabi armeabi-v7a x86
#����2����ndk-build ��������ӣ�APP_ABI="armeabi armeabi-v7a x86"
#���磺
#    Ϊ����ARMv7���豸��֧��Ӳ��FPUָ�����ʹ��  APP_ABI := armeabi-v7a 
#    ����Ϊ��֧��IA-32ָ�������ʹ��      APP_ABI := x86 
#    ����Ϊ��ͬʱ֧�������֣�����ʹ��       APP_ABI := armeabi armeabi-v7a x86
# APP_ABI := all

#APP_CFLAGS��һ��C���������ؼ��ϣ��ڱ�������ģ�������C��C++Դ����ʱ���ݡ�
#���������ڸı�һ��������Ӧ�ó�����Ҫ������ģ��Ĺ������������޸��������Android.mk�ļ�


# APP_STL
# To select the runtime you want to use, define APP_STL inside your Application.mk to one of the following values:
#
#    system          -> Use the default minimal system C++ runtime library.
#    gabi++_static   -> Use the GAbi++ runtime as a static library.
#    gabi++_shared   -> Use the GAbi++ runtime as a shared library.
#    stlport_static  -> Use the STLport runtime as a static library.
#    stlport_shared  -> Use the STLport runtime as a shared library.
#    gnustl_static   -> Use the GNU STL as a static library.
#    gnustl_shared   -> Use the GNU STL as a shared library.
#    c++_static      -> Use the LLVM libc++ as a static library.
#    c++_shared      -> Use the LLVM libc++ as a shared library.
#The 'system' runtime is the default if there is no APP_STL definition in your Application.mk. As an example, to use the static GNU STL, add a line like:
#
#    APP_STL := gnustl_static
#To your Application.mk. You can only select a single C++ runtime that all your code will depend on. It is not possible to mix shared libraries compiled against different C++ runtimes.
#
#IMPORTANT: Defining APP_STL in Android.mk has no effect!
#
#If you are not using the NDK build system, you can still use on of STLport, libc++ or GNU STL via "make-standalone-toolchain.sh --stl=". see STANDALONE-TOOLCHAIN for more details.
#
#The capabilities of the various runtimes vary. See this table:
#
#                C++       C++   Standard
#              Exceptions  RTTI    Library
#
#    system        no       no        no
#    gabi++       yes      yes        no
#    stlport      yes      yes       yes
#    gnustl       yes      yes       yes
#    libc++       yes      yes       yes

#APP_OPTIM����������ǿ�ѡ�ģ��������塰release����"debug"���ڱ�������Ӧ�ó���ģ���ʱ�򣬿��������ı����ȼ���
#     "release"ģʽ��Ĭ�ϵģ����һ����ɸ߶��Ż��Ķ����ƴ��롣
#     "debug"ģʽ���ɵ���δ�Ż��Ķ����ƴ��룬�����Լ����ܶ��BUG���������ڵ��ԡ�
# ע�⣺������Ӧ�ó����ǿɵ��Եģ������������嵥�ļ�������<application>��ǩ�а�android:debuggable������Ϊtrue����
#          Ĭ�Ͻ���debug����release����APP_OPTIM����Ϊrelease���Ը�д����
# ע�⣺���Ե���release��debug������ƣ���release�湹���������ڵ��ԻỰ���ṩ������Ϣ��һЩ�������Ż����Ҳ��ܱ���⣬
#          �����������������ʹ���벽��������ѣ���ջ���ٿ��ܲ��ɿ����ȵȡ�

#APP_OPTIM := release


#######################################################
# Latest C++11 features with Android NDK
#######################################################
# (I'm addressing the NDK version r9b) To enable C++11 support for all source code of the application (and so any modules included) make the following change in the Application.mk:
# 
# # use this to select gcc instead of clang
# NDK_TOOLCHAIN_VERSION := 4.8
# # OR use this to select the latest clang version:
# NDK_TOOLCHAIN_VERSION := clang
# 
# 
# # then enable c++11 extentions in source code
# APP_CPPFLAGS += -std=c++11
# # or use APP_CPPFLAGS := -std=gnu++11
# Otherwise, if you wish to have C++11 support only in your module, add this lines into your Android.mk instead of use APP_CPPFLAGS
# 
# LOCAL_CPPFLAGS += -std=c++11
# Read more here: http://adec.altervista.org/blog/ndk_c11_support/
