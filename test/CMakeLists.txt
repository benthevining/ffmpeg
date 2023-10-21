set (install_dir "${CMAKE_CURRENT_BINARY_DIR}/test-install")

add_test (NAME ffmpeg.install
		  COMMAND "${CMAKE_COMMAND}" 
		  	--install "${ffmpeg_BINARY_DIR}"
		  	--prefix "${install_dir}")

set_tests_properties (ffmpeg.install PROPERTIES FIXTURES_SETUP ffmpegInstall)

set (subbuild_dir "${CMAKE_CURRENT_BINARY_DIR}/subbuild")

add_test (NAME ffmpeg.find_package
		  COMMAND "${CMAKE_COMMAND}"
		  	-S "${CMAKE_CURRENT_LIST_DIR}/subproject"
		  	-B "${subbuild_dir}"
		  	-G "${CMAKE_GENERATOR}"
		  	-D "CMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
		  	-D "CMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}"
		  	-D "CMAKE_PREFIX_PATH=${install_dir}")

set_tests_properties (ffmpeg.find_package PROPERTIES FIXTURES_REQUIRED ffmpegInstall)

add_test (NAME ffmpeg.uninstall
		  COMMAND "${CMAKE_COMMAND}" -E rm -rf "${install_dir}" "${subbuild_dir}")

set_tests_properties (ffmpeg.uninstall PROPERTIES FIXTURES_CLEANUP ffmpegInstall)

set_property (DIRECTORY APPEND PROPERTY ADDITIONAL_CLEAN_FILES "${install_dir}" "${subbuild_dir}")
