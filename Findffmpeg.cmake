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

if(${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
	unset (ffmpeg_actual_component_list)
	foreach(ffmpeg_requested_component IN LISTS ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
		string (TOLOWER "${ffmpeg_requested_component}" ffmpeg_requested_component)
		if("${ffmpeg_requested_component}" IN_LIST ffmpeg_valid_components)
			list (APPEND ffmpeg_actual_component_list "${ffmpeg_requested_component}")
		else()
			if(NOT ${CMAKE_FIND_PACKAGE_NAME}_FIND_QUIETLY)
				message (AUTHOR_WARNING "ffmpeg: Invalid component requested: '${ffmpeg_requested_component}'")
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

unset (ffmpeg_found_components)

# ffmpeg
if(ffmpeg IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)

	find_program (FFMPEG_FFMPEG_PROGRAM ffmpeg DOC "ffmpeg command line tool")

	if(FFMPEG_FFMPEG_PROGRAM)
		add_executable (ffmpeg::ffmpeg IMPORTED)
		set_target_properties (ffmpeg::ffmpeg PROPERTIES IMPORTED_LOCATION "${FFMPEG_FFMPEG_PROGRAM}")
		set (${CMAKE_FIND_PACKAGE_NAME}_ffmpeg_FOUND TRUE)
		list (APPEND ffmpeg_found_components ffmpeg)
	else()
		set (${CMAKE_FIND_PACKAGE_NAME}_ffmpeg_FOUND FALSE)

		if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_ffmpeg)
			list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "ffmpeg not found")
			set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
		endif()
	endif()

endif()

# ffplay
if(ffplay IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)

	find_program (FFMPEG_FFPLAY_PROGRAM ffplay DOC "ffplay command line tool")

	if(FFMPEG_FFPLAY_PROGRAM)
		add_executable (ffmpeg::ffplay IMPORTED)
		set_target_properties (ffmpeg::ffplay PROPERTIES IMPORTED_LOCATION "${FFMPEG_FFPLAY_PROGRAM}")
		set (${CMAKE_FIND_PACKAGE_NAME}_ffplay_FOUND TRUE)
		list (APPEND ffmpeg_found_components ffplay)
	else()
		set (${CMAKE_FIND_PACKAGE_NAME}_ffplay_FOUND FALSE)

		if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_ffplay)
			list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "ffplay not found")
			set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
		endif()
	endif()

endif()

# ffprobe
if(ffprobe IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)

	find_program (FFMPEG_FFPROBE_PROGRAM ffprobe DOC "ffprobe command line tool")

	if(FFMPEG_FFPROBE_PROGRAM)
		add_executable (ffmpeg::ffprobe IMPORTED)
		set_target_properties (ffmpeg::ffprobe PROPERTIES IMPORTED_LOCATION "${FFMPEG_FFPROBE_PROGRAM}")
		set (${CMAKE_FIND_PACKAGE_NAME}_ffprobe_FOUND TRUE)
		list (APPEND ffmpeg_found_components ffprobe)
	else()
		set (${CMAKE_FIND_PACKAGE_NAME}_ffprobe_FOUND FALSE)

		if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_ffprobe)
			list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "ffprobe not found")
			set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
		endif()
	endif()

endif()

# libavcodec
if(libavcodec IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)

	find_library (FFMPEG_LIBAVCODEC_LIBRARY libavcodec DOC "libavcodec library")

	find_file (FFMPEG_LIBAVCODEC_INCLUDES avcodec.h
			   PATH_SUFFIXES libavcodec
			   DOC "libavcodec include directory")

	if(FFMPEG_LIBAVCODEC_LIBRARY AND FFMPEG_LIBAVCODEC_INCLUDES)
		add_library (ffmpeg::libavcodec UNKNOWN IMPORTED)
		set_target_properties (ffmpeg::libavcodec PROPERTIES 
			IMPORTED_LOCATION "${FFMPEG_LIBAVCODEC_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${FFMPEG_LIBAVCODEC_INCLUDES}")
		set (${CMAKE_FIND_PACKAGE_NAME}_libavcodec_FOUND TRUE)
		list (APPEND ffmpeg_found_components libavcodec)
	else()
		set (${CMAKE_FIND_PACKAGE_NAME}_libavcodec_FOUND FALSE)

		if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_libavcodec)
			list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "libavcodec not found")
			set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
		endif()
	endif()

endif()

# libavdevice
if(libavdevice IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)

	find_library (FFMPEG_LIBAVDEVICE_LIBRARY libavdevice DOC "libavdevice library")

	find_file (FFMPEG_LIBAVDEVICE_INCLUDES avdevice.h
			   PATH_SUFFIXES libavdevice
			   DOC "libavdevice include directory")

	if(FFMPEG_LIBAVDEVICE_LIBRARY AND FFMPEG_LIBAVDEVICE_INCLUDES)
		add_library (ffmpeg::libavdevice UNKNOWN IMPORTED)
		set_target_properties (ffmpeg::libavdevice PROPERTIES
			IMPORTED_LOCATION "${FFMPEG_LIBAVDEVICE_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${FFMPEG_LIBAVDEVICE_INCLUDES}")
		set (${CMAKE_FIND_PACKAGE_NAME}_libavdevice_FOUND TRUE)
		list (APPEND ffmpeg_found_components libavdevice)
	else()
		set (${CMAKE_FIND_PACKAGE_NAME}_libavdevice_FOUND FALSE)

		if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_libavdevice)
			list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "libavdevice not found")
			set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
		endif()
	endif()

endif()

# libavfilter
if(libavfilter IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)

	find_library (FFMPEG_LIBAVFILTER_LIBRARY libavfilter DOC "libavfilter library")

	find_file (FFMPEG_LIBAVFILTER_INCLUDES avfilter.h
			   PATH_SUFFIXES libavfilter
			   DOC "libavfilter include directory")

	if(FFMPEG_LIBAVFILTER_LIBRARY AND FFMPEG_LIBAVFILTER_INCLUDES)
		add_library (ffmpeg::libavfilter UNKNOWN IMPORTED)
		set_target_properties (ffmpeg::libavfilter PROPERTIES
			IMPORTED_LOCATION "${FFMPEG_LIBAVFILTER_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${FFMPEG_LIBAVFILTER_INCLUDES}")
		set (${CMAKE_FIND_PACKAGE_NAME}_libavfilter_FOUND TRUE)
		list (APPEND ffmpeg_found_components libavfilter)
	else()
		set (${CMAKE_FIND_PACKAGE_NAME}_libavfilter_FOUND FALSE)

		if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_libavfilter)
			list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "libavfilter not found")
			set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
		endif()
	endif()

endif()

# libavformat
if(libavformat IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)

	find_library (FFMPEG_LIBAVFORMAT_LIBRARY libavformat DOC "libavformat library")

	find_file (FFMPEG_LIBAVFORMAT_INCLUDES avformat.h
			   PATH_SUFFIXES libavformat
			   DOC "libavformat include directory")

	if(FFMPEG_LIBAVFORMAT_LIBRARY AND FFMPEG_LIBAVFORMAT_INCLUDES)
		add_library (ffmpeg::libavformat UNKNOWN IMPORTED)
		set_target_properties (ffmpeg::libavformat PROPERTIES
			IMPORTED_LOCATION "${FFMPEG_LIBAVFORMAT_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${FFMPEG_LIBAVFORMAT_INCLUDES}")
		set (${CMAKE_FIND_PACKAGE_NAME}_libavformat_FOUND TRUE)
		list (APPEND ffmpeg_found_components libavformat)
	else()
		set (${CMAKE_FIND_PACKAGE_NAME}_libavformat_FOUND FALSE)

		if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_libavformat)
			list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "libavformat not found")
			set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
		endif()
	endif()

endif()

# libavutil
if(libavutil IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)

	find_library (FFMPEG_LIBAVUTIL_LIBRARY libavutil DOC "libavutil library")

	find_file (FFMPEG_LIBAVUTIL_INCLUDES avutil.h
			   PATH_SUFFIXES libavutil
			   DOC "libavutil include directory")

	if(FFMPEG_LIBAVUTIL_LIBRARY AND FFMPEG_LIBAVUTIL_INCLUDES)
		add_library (ffmpeg::libavutil UNKNOWN IMPORTED)
		set_target_properties (ffmpeg::libavutil PROPERTIES
			IMPORTED_LOCATION "${FFMPEG_LIBAVUTIL_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${FFMPEG_LIBAVUTIL_INCLUDES}")
		set (${CMAKE_FIND_PACKAGE_NAME}_libavutil_FOUND TRUE)
		list (APPEND ffmpeg_found_components libavutil)
	else()
		set (${CMAKE_FIND_PACKAGE_NAME}_libavutil_FOUND FALSE)

		if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_libavutil)
			list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "libavutil not found")
			set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
		endif()
	endif()

endif()

# libswresample
if(libswresample IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)

	find_library (FFMPEG_LIBSWRESAMPLE_LIBRARY libswresample DOC "libswresample library")

	find_file (FFMPEG_LIBSWRESAMPLE_INCLUDES swresample.h
			   PATH_SUFFIXES libswresample
			   DOC "libswresample include directory")

	if(FFMPEG_LIBSWRESAMPLE_LIBRARY AND FFMPEG_LIBSWRESAMPLE_INCLUDES)
		add_library (ffmpeg::libswresample UNKNOWN IMPORTED)
		set_target_properties (ffmpeg::libswresample PROPERTIES
			IMPORTED_LOCATION "${FFMPEG_LIBSWRESAMPLE_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${FFMPEG_LIBSWRESAMPLE_INCLUDES}")
		set (${CMAKE_FIND_PACKAGE_NAME}_libswresample_FOUND TRUE)
		list (APPEND ffmpeg_found_components libswresample)
	else()
		set (${CMAKE_FIND_PACKAGE_NAME}_libswresample_FOUND FALSE)

		if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_libswresample)
			list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "libswresample not found")
			set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
		endif()
	endif()

endif()

# libswscale
if(libswscale IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)

	find_library (FFMPEG_LIBSWSCALE_LIBRARY libswscale DOC "libswscale library")

	find_file (FFMPEG_LIBSWSCALE_INCLUDES swscale.h
			   PATH_SUFFIXES libswscale
			   DOC "libswscale include directory")

	if(FFMPEG_LIBSWSCALE_LIBRARY AND FFMPEG_LIBSWSCALE_INCLUDES)
		add_library (ffmpeg::libswscale UNKNOWN IMPORTED)
		set_target_properties (ffmpeg::libswscale PROPERTIES
			IMPORTED_LOCATION "${FFMPEG_LIBSWSCALE_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${FFMPEG_LIBSWSCALE_INCLUDES}")
		set (${CMAKE_FIND_PACKAGE_NAME}_libswscale_FOUND TRUE)
		list (APPEND ffmpeg_found_components libswscale)
	else()
		set (${CMAKE_FIND_PACKAGE_NAME}_libswscale_FOUND FALSE)

		if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_libswscale)
			list (APPEND ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "libswscale not found")
			set (${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
		endif()
	endif()

endif()

#

include (FindPackageMessage)

if(${CMAKE_FIND_PACKAGE_NAME}_FOUND)
	list (JOIN ffmpeg_found_components " " ffmpeg_comp_display_list)
	set (ffmpeg_pkg_msg "Found ffmpeg (found components ${ffmpeg_comp_display_list})")
else()
	set (ffmpeg_pkg_msg "ffmpeg - not found")
endif()

find_package_message (
	"${CMAKE_FIND_PACKAGE_NAME}"
	"${ffmpeg_pkg_msg}"
	"${ffmpeg_found_components}"
)
