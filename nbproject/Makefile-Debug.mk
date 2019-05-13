#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Environment
MKDIR=mkdir
CP=cp
GREP=grep
NM=nm
CCADMIN=CCadmin
RANLIB=ranlib
CC=gcc
CCC=g++
CXX=g++
FC=gfortran
AS=as

# Macros
CND_PLATFORM=MinGW-Windows
CND_DLIB_EXT=dll
CND_CONF=Debug
CND_DISTDIR=dist
CND_BUILDDIR=build

# Include project Makefile
include Makefile

# Object Directory
OBJECTDIR=${CND_BUILDDIR}/${CND_CONF}/${CND_PLATFORM}

# Object Files
OBJECTFILES= \
	${OBJECTDIR}/_ext/b8f32e06/Img.o \
	${OBJECTDIR}/_ext/b8f32e06/Label.o \
	${OBJECTDIR}/cpp/App.o \
	${OBJECTDIR}/cpp/Camera.o \
	${OBJECTDIR}/cpp/Map.o \
	${OBJECTDIR}/cpp/Npc.o \
	${OBJECTDIR}/main.o


# C Compiler Flags
CFLAGS=

# CC Compiler Flags
CCFLAGS=
CXXFLAGS=

# Fortran Compiler Flags
FFLAGS=

# Assembler Flags
ASFLAGS=

# Link Libraries and Options
LDLIBSOPTIONS=-L/C/lib -lSDL2 -lSDL2main -lSDL2_image -lSDL2_mixer -lSDL2_ttf -llua

# Build Targets
.build-conf: ${BUILD_SUBPROJECTS}
	"${MAKE}"  -f nbproject/Makefile-${CND_CONF}.mk ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/pmr.exe

${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/pmr.exe: ${OBJECTFILES}
	${MKDIR} -p ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}
	${LINK.cc} -o ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/pmr ${OBJECTFILES} ${LDLIBSOPTIONS}

${OBJECTDIR}/_ext/b8f32e06/Img.o: /C/temp/PMR/cpp/Img.cpp
	${MKDIR} -p ${OBJECTDIR}/_ext/b8f32e06
	${RM} "$@.d"
	$(COMPILE.cc) -g -Ihpp -Icpp -I/C/include -I/C/include/SDL2 -I/C/lib -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/_ext/b8f32e06/Img.o /C/temp/PMR/cpp/Img.cpp

${OBJECTDIR}/_ext/b8f32e06/Label.o: /C/temp/PMR/cpp/Label.cpp
	${MKDIR} -p ${OBJECTDIR}/_ext/b8f32e06
	${RM} "$@.d"
	$(COMPILE.cc) -g -Ihpp -Icpp -I/C/include -I/C/include/SDL2 -I/C/lib -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/_ext/b8f32e06/Label.o /C/temp/PMR/cpp/Label.cpp

${OBJECTDIR}/cpp/App.o: cpp/App.cpp
	${MKDIR} -p ${OBJECTDIR}/cpp
	${RM} "$@.d"
	$(COMPILE.cc) -g -Ihpp -Icpp -I/C/include -I/C/include/SDL2 -I/C/lib -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/cpp/App.o cpp/App.cpp

${OBJECTDIR}/cpp/Camera.o: cpp/Camera.cpp
	${MKDIR} -p ${OBJECTDIR}/cpp
	${RM} "$@.d"
	$(COMPILE.cc) -g -Ihpp -Icpp -I/C/include -I/C/include/SDL2 -I/C/lib -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/cpp/Camera.o cpp/Camera.cpp

${OBJECTDIR}/cpp/Map.o: cpp/Map.cpp
	${MKDIR} -p ${OBJECTDIR}/cpp
	${RM} "$@.d"
	$(COMPILE.cc) -g -Ihpp -Icpp -I/C/include -I/C/include/SDL2 -I/C/lib -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/cpp/Map.o cpp/Map.cpp

${OBJECTDIR}/cpp/Npc.o: cpp/Npc.cpp
	${MKDIR} -p ${OBJECTDIR}/cpp
	${RM} "$@.d"
	$(COMPILE.cc) -g -Ihpp -Icpp -I/C/include -I/C/include/SDL2 -I/C/lib -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/cpp/Npc.o cpp/Npc.cpp

${OBJECTDIR}/main.o: main.cpp
	${MKDIR} -p ${OBJECTDIR}
	${RM} "$@.d"
	$(COMPILE.cc) -g -Ihpp -Icpp -I/C/include -I/C/include/SDL2 -I/C/lib -MMD -MP -MF "$@.d" -o ${OBJECTDIR}/main.o main.cpp

# Subprojects
.build-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${CND_BUILDDIR}/${CND_CONF}

# Subprojects
.clean-subprojects:

# Enable dependency checking
.dep.inc: .depcheck-impl

include .dep.inc
