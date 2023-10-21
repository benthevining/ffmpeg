# TODO: version checking

cmake_minimum_required (VERSION 3.25 FATAL_ERROR)

include (FeatureSummary)

set_package_properties (ffmpeg PROPERTIES
	URL "https://www.ffmpeg.org/"
	DESCRIPTION "FFmpeg is a collection of libraries and tools to process multimedia content such as audio, video, subtitles and related metadata.")

set (${CMAKE_FIND_PACKAGE_NAME}_FOUND TRUE)

set (ffmpeg_valid_components
		ffmpeg ffplay ffprobe
		libavcodec libavdevice libavfilter libavformat libavutil libswresample libswscale
)

# check for invalid component names

if(${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
	unset (ffmpeg_actual_component_list)
	list (REMOVE_DUPLICATES ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
	foreach(ffmpeg_requested_component IN LISTS ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
		string (TOLOWER "${ffmpeg_requested_component}" ffmpeg_requested_component)
		if("${ffmpeg_requested_component}" IN_LIST ffmpeg_valid_components)
			list (APPEND ffmpeg_actual_component_list "${ffmpeg_requested_component}")
		else()
			if(NOT ${CMAKE_FIND_PACKAGE_NAME}_FIND_QUIETLY)
				message (AUTHOR_WARNING "${CMAKE_FIND_PACKAGE_NAME}: Invalid component requested: '${ffmpeg_requested_component}'")
			endif()

			set (${CMAKE_FIND_PACKAGE_NAME}_${ffmpeg_requested_component}_FOUND FALSE)

			if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_${ffmpeg_requested_component})
				list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "Invalid component requested: '${ffmpeg_requested_component}'")
				set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
			endif()
		endif()
	endforeach()
	set (${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS ${ffmpeg_actual_component_list})
else()
	set (${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS ${ffmpeg_valid_components})
endif()

# component dependencies

set (ffmpeg_libavcodec_deps libavutil libswresample)
set (ffmpeg_libavdevice_deps libavfilter libswscale libavformat libavcodec libswresample libavutil)
set (ffmpeg_libavfilter_deps libswscale libavformat libavcodec libswresample libavutil)
set (ffmpeg_libavformat_deps libavcodec libswresample libavutil)
set (ffmpeg_libswresample_deps libavutil)
set (ffmpeg_libswscale_deps libavutil)

foreach(ffmpeg_component IN LISTS ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
	foreach(ffmpeg_comp_dep IN LISTS ffmpeg_${ffmpeg_component}_deps)
		if(NOT "${ffmpeg_comp_dep}" IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
			list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS "${ffmpeg_comp_dep}")

			if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_${ffmpeg_component})
				set (${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_${ffmpeg_comp_dep} TRUE)
			endif()
		endif()
	endforeach()
endforeach()

# search for each component, create imported targets

unset (ffmpeg_found_components)

macro(__ffmpeg_find_program name)
	if(${name} IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)

		string (TOUPPER "${name}" ffmpeg_program_var)
		set (ffmpeg_program_var "FFMPEG_${ffmpeg_program_var}_PROGRAM")

		find_program (${ffmpeg_program_var} ${name} DOC "${name} command line tool")

		if(${ffmpeg_program_var})
			add_executable (ffmpeg::${name} IMPORTED)
			set_target_properties (ffmpeg::${name} PROPERTIES IMPORTED_LOCATION "${${ffmpeg_program_var}}")
			set (${CMAKE_FIND_PACKAGE_NAME}_${name}_FOUND TRUE)
			list (APPEND ffmpeg_found_components ${name})
		else()
			set (${CMAKE_FIND_PACKAGE_NAME}_${name}_FOUND FALSE)

			if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_${name})
				list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "${name} not found")
				set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
			endif()
		endif()

	endif()
endmacro()

__ffmpeg_find_program (ffmpeg)
__ffmpeg_find_program (ffplay)
__ffmpeg_find_program (ffprobe)

function(__ffmpeg_find_library_internal name)
	if(TARGET ffmpeg::${name})
		return()
	endif()

	foreach(dep_lib IN LISTS ffmpeg_${name}_deps)
		__ffmpeg_find_library ("${dep_lib}")

		if(NOT TARGET ffmpeg::${dep_lib})
			return()
		endif()
	endforeach()

	string (TOUPPER "${name}" upper_name)

	set (lib_var "FFMPEG_${upper_name}_LIBRARY")
	set (inc_var "FFMPEG_${upper_name}_INCLUDES")

	find_library (${lib_var} ${name} DOC "${name} library")

	string (SUBSTRING "${name}" 3 -1 header_name)

	find_file (${inc_var} "${header_name}.h"
			   PATH_SUFFIXES ${name}
			   DOC "${name} include directory")

	if(NOT (${lib_var} AND ${inc_var}))
		return()
	endif()

	add_library (ffmpeg::${name} UNKNOWN IMPORTED)

	set_target_properties (ffmpeg::${name} PROPERTIES 
		IMPORTED_LOCATION "${${lib_var}}"
		INTERFACE_INCLUDE_DIRECTORIES "${${inc_var}}")

	foreach(dep_lib IN LISTS ffmpeg_${name}_deps)
		target_link_libraries (ffmpeg::${name} INTERFACE ffmpeg::${dep_lib})
	endforeach()
endfunction()

macro(__ffmpeg_find_library name)
	if(${name} IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)

		__ffmpeg_find_library_internal ("${name}")

		if(TARGET ffmpeg::${name})
			set (${CMAKE_FIND_PACKAGE_NAME}_${name}_FOUND TRUE)
			list (APPEND ffmpeg_found_components ${name})
		else()
			set (${CMAKE_FIND_PACKAGE_NAME}_${name}_FOUND FALSE)

			if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_${name})
				list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "${name} not found")
				set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
			endif()
		endif()

	endif()
endmacro()

__ffmpeg_find_library (libavcodec)
__ffmpeg_find_library (libavdevice)
__ffmpeg_find_library (libavfilter)
__ffmpeg_find_library (libavformat)
__ffmpeg_find_library (libavutil)
__ffmpeg_find_library (libswresample)
__ffmpeg_find_library (libswscale)

#

include (FindPackageMessage)

if(${CMAKE_FIND_PACKAGE_NAME}_FOUND)
	list (JOIN ffmpeg_found_components " " ffmpeg_comp_display_list)
	set (ffmpeg_pkg_msg "Found ${CMAKE_FIND_PACKAGE_NAME} (components ${ffmpeg_comp_display_list})")
else()
	set (ffmpeg_pkg_msg "${CMAKE_FIND_PACKAGE_NAME} - not found")
endif()

find_package_message (
	"${CMAKE_FIND_PACKAGE_NAME}"
	"${ffmpeg_pkg_msg}"
	"${ffmpeg_found_components}"
)
