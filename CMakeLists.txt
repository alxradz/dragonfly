cmake_minimum_required (VERSION 2.8)

set(CMAKE_VERBOSE_MAKEFILE on)

project (dragonfly)
set (APPLICATION_NAME "Dragonfly")
set (APPLICATION_CODENAME "dragonfly")
set (APPLICATION_COPYRIGHT_YEARS "2014")
set (APPLICATION_VERSION_MAJOR "1")
set (APPLICATION_VERSION_MINOR "0")
set (APPLICATION_VERSION_PATCH "0")
set (APPLICATION_VERSION_TYPE "SNAPSHOT")
set (APPLICATION_VERSION_STRING "${APPLICATION_VERSION_MAJOR}.${APPLICATION_VERSION_MINOR}.${APPLICATION_VERSION_PATCH}-${APPLICATION_VERSION_TYPE}")
set (APPLICATION_VENDOR_ID "dragonfly")
set (APPLICATION_VENDOR_NAME "Alex Radeski")
set (APPLICATION_VENDOR_URL "http://www.memcrunch.org/")
set (APPLICATION_ID "${APPLICATION_VENDOR_ID}-${PROJECT_NAME}-${APPLICATION_VERSION_STRING}")

list (APPEND CMAKE_PREFIX_PATH "${PROJECT_SOURCE_DIR}")
list (APPEND CMAKE_PREFIX_PATH "${PROJECT_SOURCE_DIR}/tools")
set (CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/tools/share/cmake")

#set_property(GLOBAL PROPERTY RULE_MESSAGES OFF)
#set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${PROJECT_SOURCE_DIR}/tools/share/gcc/gccfilter -a -r -c ")

set(CHIBIOS_ARDUINO_DIR "${PROJECT_SOURCE_DIR}/tools/chibios_duino")

#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99 -mmcu=${MCU} -DF_CPU=${FREQ}UL") 
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -Wall -Wstrict-prototypes") 
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-strict-aliasing -mshort-calls -fno-unit-at-a-time -Wundef -Wunreachable-code -Wsign-compare") 
#set(CMAKE_CXX_FLAGS ${CMAKE_C_FLAGS}) 
#set(CMAKE_EXE_LINKER_FLAGS "-lm") 
#set(CMAKE_CXX_FLAGS "-v")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x -fmessage-length=0 -fmax-errors=1 -Wall -Wextra")
#set(CMAKE_CXX_FLAGS_DEBUG "-g3")
set(CMAKE_C_FLAGS      "-std=gnu99 -I${PROJECT_SOURCE_DIR}/include -I${CHIBIOS_ARDUINO_DIR}/include")
#set(ARDUINO_C_FLAGS "${ARDUINO_C_FLAGS} -std=gnu99 ")
#set(ARDUINO_C_FLAGS      "-ffunction-sections -fdata-sections")
#set(ARDUINO_CXX_FLAGS    "${ARDUINO_C_FLAGS} -fno-exceptions")
#set(ARDUINO_LINKER_FLAGS "-Wl,--gc-sections")

file (GLOB DRAGONFLY_SRCS
    ${CHIBIOS_ARDUINO_DIR}/src/*.c
    ${PROJECT_SOURCE_DIR}/src/*.c
 )
    
generate_arduino_firmware(dragonfly
     SRCS  ${DRAGONFLY_SRCS}
     PORT  /dev/ttyACM0
     BOARD uno
     SERIAL picocom @SERIAL_PORT@ -b 9600 -l)