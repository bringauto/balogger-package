##
#
# Download and initialize variable balogger_ROOT
#

IF(NOT CMAKE_BUILD_TYPE)
	MESSAGE(FATAL_ERROR "Balogger package does not provide multi-conf support!")
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)
CMLIB_DEPENDENCY(
	URI "https://github.com/bringauto/cmake-package-tools.git"
	URI_TYPE GIT
	TYPE MODULE
)
FIND_PACKAGE(CMAKE_PACKAGE_TOOLS REQUIRED)

SET(platform_string)
CMAKE_PACKAGE_TOOLS_PLATFORM_STRING(platform_string)

SET(version v1.1.0)
SET(balogger_url)
IF(CMAKE_BUILD_TYPE STREQUAL "Debug")
	SET(balogger_url
		"https://github.com/bringauto/balogger-package/releases/download/${version}/libbringauto_loggerd-dev_${version}_${platform_string}.zip"
	)
ELSE()
	SET(balogger_url
		"https://github.com/bringauto/balogger-package/releases/download/${version}/libbringauto_logger-dev_${version}_${platform_string}.zip"
	)
ENDIF()

CMLIB_DEPENDENCY(
	URI "${balogger_url}"
	TYPE ARCHIVE
	OUTPUT_PATH_VAR _balogger_ROOT
)

SET(libbringauto_logger_ROOT "${_balogger_ROOT}"
	CACHE STRING
	"balogger root directory"
	FORCE
)

UNSET(_balogger_ROOT)
UNSET(balogger_url)
UNSET(version)
UNSET(platform_string)
