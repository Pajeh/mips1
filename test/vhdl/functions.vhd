library IEEE;
  use IEEE.std_logic_1164.ALL;

entity functions is
  generic (
    CORE        : string(2 downto 1);
    ADDR_LIMIT  : integer
  );
  port (
    addr      : in integer
  );
end entity functions;


architecture behav_functions of functions is

begin

  process( addr )
  begin
    if addr <= ADDR_LIMIT then
      case addr is
       when 16  => report CORE &" main_enc";
       when 472  => report CORE &" main_dec";
       when 1404  => report CORE &" opj_stream_read_seek";
       when 1560  => report CORE &" opj_stream_default_read";
       when 1568  => report CORE &" opj_stream_default_write";
       when 1576  => report CORE &" opj_stream_default_skip";
       when 1588  => report CORE &" opj_stream_default_seek";
       when 1596  => report CORE &" opj_stream_read_skip";
       when 2168  => report CORE &" opj_write_bytes_BE";
       when 2212  => report CORE &" opj_write_bytes_LE";
       when 2316  => report CORE &" opj_read_bytes_BE";
       when 2396  => report CORE &" opj_read_bytes_LE";
       when 2508  => report CORE &" opj_write_double_BE";
       when 2544  => report CORE &" opj_write_double_LE";
       when 2588  => report CORE &" opj_read_double_BE";
       when 2624  => report CORE &" opj_read_double_LE";
       when 2660  => report CORE &" opj_write_float_BE";
       when 2676  => report CORE &" opj_write_float_LE";
       when 2712  => report CORE &" opj_read_float_BE";
       when 2740  => report CORE &" opj_read_float_LE";
       when 2776  => report CORE &" opj_stream_create";
       when 3028  => report CORE &" opj_stream_default_create";
       when 3040  => report CORE &" opj_stream_destroy";
       when 3124  => report CORE &" opj_stream_set_read_function";
       when 3164  => report CORE &" opj_stream_set_seek_function";
       when 3184  => report CORE &" opj_stream_set_write_function";
       when 3224  => report CORE &" opj_stream_set_skip_function";
       when 3244  => report CORE &" opj_stream_set_user_data";
       when 3268  => report CORE &" opj_stream_set_user_data_length";
       when 3292  => report CORE &" opj_stream_read_data";
       when 4056  => report CORE &" opj_stream_flush";
       when 4256  => report CORE &" opj_stream_write_data";
       when 4576  => report CORE &" opj_stream_write_skip";
       when 4984  => report CORE &" opj_stream_write_seek";
       when 5140  => report CORE &" opj_stream_tell";
       when 5156  => report CORE &" opj_stream_get_number_byte_left";
       when 5372  => report CORE &" opj_stream_skip";
       when 5456  => report CORE &" opj_stream_seek";
       when 5540  => report CORE &" opj_stream_has_seek";
       when 5572  => report CORE &" opj_event_msg";
       when 5832  => report CORE &" opj_set_default_event_handler";
       when 5868  => report CORE &" opj_image_create0";
       when 5880  => report CORE &" opj_image_destroy";
       when 6060  => report CORE &" opj_image_create";
       when 6432  => report CORE &" opj_image_comp_header_update";
       when 7076  => report CORE &" opj_copy_image_header";
       when 7596  => report CORE &" opj_image_tile_create";
       when 8060  => report CORE &" opj_set_info_handler";
       when 8092  => report CORE &" opj_set_warning_handler";
       when 8124  => report CORE &" opj_set_error_handler";
       when 8156  => report CORE &" opj_version";
       when 8168  => report CORE &" opj_create_decompress";
       when 8640  => report CORE &" opj_set_default_decoder_parameters";
       when 8712  => report CORE &" opj_setup_decoder";
       when 8848  => report CORE &" opj_read_header";
       when 8948  => report CORE &" opj_decode";
       when 9004  => report CORE &" opj_set_decode_area";
       when 9104  => report CORE &" opj_read_tile_header";
       when 9272  => report CORE &" opj_decode_tile_data";
       when 9396  => report CORE &" opj_get_decoded_tile";
       when 9492  => report CORE &" opj_set_decoded_resolution_factor";
       when 9580  => report CORE &" opj_create_compress";
       when 9880  => report CORE &" opj_set_default_encoder_parameters";
       when 10028  => report CORE &" opj_setup_encoder";
       when 10116  => report CORE &" opj_start_compress";
       when 10180  => report CORE &" opj_encode";
       when 10236  => report CORE &" opj_end_compress";
       when 10292  => report CORE &" opj_end_decompress";
       when 10348  => report CORE &" opj_set_MCT";
       when 10600  => report CORE &" opj_write_tile";
       when 10708  => report CORE &" opj_destroy_codec";
       when 10820  => report CORE &" opj_dump_codec";
       when 10868  => report CORE &" opj_get_cstr_info";
       when 10900  => report CORE &" opj_destroy_cstr_info";
       when 10988  => report CORE &" opj_get_cstr_index";
       when 11020  => report CORE &" opj_destroy_cstr_index";
       when 11084  => report CORE &" opj_stream_create_file_stream";
       when 11376  => report CORE &" opj_stream_create_default_file_stream";
       when 11824  => report CORE &" color_sycc_to_rgb";
       when 14292  => report CORE &" bmptoimage";
       when 18184  => report CORE &" imagetobmp";
       when 55420  => report CORE &" opj_j2k_convert_progression_order";
       when 55476  => report CORE &" opj_j2k_setup_decoder";
       when 55524  => report CORE &" opj_j2k_end_decompress";
       when 55532  => report CORE &" opj_j2k_read_header";
       when 55916  => report CORE &" opj_j2k_setup_mct_encoding";
       when 56944  => report CORE &" opj_j2k_setup_encoder";
       when 62848  => report CORE &" j2k_destroy_cstr_index";
       when 63128  => report CORE &" opj_j2k_destroy";
       when 63628  => report CORE &" opj_j2k_create_compress";
       when 63792  => report CORE &" opj_j2k_read_tile_header";
       when 66344  => report CORE &" opj_j2k_decode_tile";
       when 68652  => report CORE &" opj_j2k_set_decode_area";
       when 70316  => report CORE &" opj_j2k_create_decompress";
       when 70612  => report CORE &" j2k_dump_image_comp_header";
       when 70908  => report CORE &" j2k_dump_image_header";
       when 71308  => report CORE &" j2k_dump";
       when 72532  => report CORE &" j2k_get_cstr_info";
       when 73068  => report CORE &" j2k_get_cstr_index";
       when 73892  => report CORE &" opj_j2k_decode";
       when 74228  => report CORE &" opj_j2k_get_tile";
       when 75544  => report CORE &" opj_j2k_set_decoded_resolution_factor";
       when 75780  => report CORE &" opj_j2k_encode";
       when 77484  => report CORE &" opj_j2k_end_compress";
       when 77680  => report CORE &" opj_j2k_start_compress";
       when 78460  => report CORE &" opj_j2k_write_tile";
       when 81448  => report CORE &" opj_jp2_write_jp2h";
       when 84000  => report CORE &" opj_jp2_default_validation";
       when 84380  => report CORE &" opj_jp2_skip_jp2c";
       when 91204  => report CORE &" opj_jp2_decode";
       when 91672  => report CORE &" opj_jp2_setup_decoder";
       when 91740  => report CORE &" opj_jp2_setup_encoder";
       when 92892  => report CORE &" opj_jp2_encode";
       when 92904  => report CORE &" opj_jp2_end_decompress";
       when 93084  => report CORE &" opj_jp2_end_compress";
       when 93264  => report CORE &" opj_jp2_start_compress";
       when 93600  => report CORE &" opj_jp2_read_header";
       when 93836  => report CORE &" opj_jp2_read_tile_header";
       when 93848  => report CORE &" opj_jp2_write_tile";
       when 93860  => report CORE &" opj_jp2_decode_tile";
       when 93872  => report CORE &" opj_jp2_destroy";
       when 94328  => report CORE &" opj_jp2_set_decode_area";
       when 94340  => report CORE &" opj_jp2_get_tile";
       when 94784  => report CORE &" opj_jp2_create";
       when 95004  => report CORE &" jp2_dump";
       when 95064  => report CORE &" jp2_get_cstr_index";
       when 95076  => report CORE &" jp2_get_cstr_info";
       when 95088  => report CORE &" opj_jp2_set_decoded_resolution_factor";
       when 95100  => report CORE &" opj_matrix_inversion_f";
       when 96572  => report CORE &" opj_mct_get_mct_norms";
       when 96584  => report CORE &" opj_mct_get_mct_norms_real";
       when 96596  => report CORE &" opj_mct_encode";
       when 96680  => report CORE &" opj_mct_decode";
       when 96760  => report CORE &" opj_mct_getnorm";
       when 96792  => report CORE &" opj_mct_encode_real";
       when 98352  => report CORE &" opj_mct_decode_real";
       when 98628  => report CORE &" opj_mct_getnorm_real";
       when 98660  => report CORE &" opj_mct_encode_custom";
       when 99272  => report CORE &" opj_mct_decode_custom";
       when 99644  => report CORE &" opj_calculate_norms";
       when 102424  => report CORE &" opj_pi_check_next_level";
       when 102888  => report CORE &" opj_pi_create_encode";
       when 105080  => report CORE &" opj_pi_destroy";
       when 105696  => report CORE &" opj_pi_create_decode";
       when 106948  => report CORE &" opj_pi_initialise_encode";
       when 108228  => report CORE &" opj_pi_update_encoding_parameters";
       when 109900  => report CORE &" opj_pi_next";
       when 115188  => report CORE &" opj_tcd_create";
       when 115324  => report CORE &" opj_tcd_makelayer";
       when 116456  => report CORE &" opj_tcd_makelayer_fixed";
       when 117616  => report CORE &" opj_tcd_rateallocate_fixed";
       when 117716  => report CORE &" opj_tcd_rateallocate";
       when 120208  => report CORE &" opj_tcd_init";
       when 120404  => report CORE &" opj_tcd_destroy";
       when 121016  => report CORE &" opj_alloc_tile_component_data";
       when 121256  => report CORE &" opj_tcd_init_encode_tile";
       when 126520  => report CORE &" opj_tcd_init_decode_tile";
       when 131804  => report CORE &" opj_tcd_get_decoded_tile_size";
       when 131984  => report CORE &" opj_tcd_encode_tile";
       when 133532  => report CORE &" opj_tcd_decode_tile";
       when 135172  => report CORE &" opj_tcd_update_tile_data";
       when 136040  => report CORE &" opj_tcd_get_encoded_tile_size";
       when 136192  => report CORE &" opj_tcd_copy_tile_data";
       when 136772  => report CORE &" opj_tgt_create";
       when 137460  => report CORE &" opj_tgt_destroy";
       when 137532  => report CORE &" opj_tgt_init";
       when 138188  => report CORE &" opj_tgt_reset";
       when 138248  => report CORE &" opj_tgt_setvalue";
       when 138344  => report CORE &" opj_tgt_encode";
       when 138688  => report CORE &" opj_tgt_decode";
       when 138988  => report CORE &" opj_bio_create";
       when 138996  => report CORE &" opj_bio_destroy";
       when 139020  => report CORE &" opj_bio_numbytes";
       when 139036  => report CORE &" opj_bio_init_enc";
       when 139068  => report CORE &" opj_bio_init_dec";
       when 139096  => report CORE &" opj_bio_write";
       when 139236  => report CORE &" opj_bio_read";
       when 139444  => report CORE &" opj_bio_flush";
       when 139616  => report CORE &" opj_bio_inalign";
       when 146688  => report CORE &" opj_dwt_encode";
       when 147620  => report CORE &" opj_dwt_decode";
       when 148548  => report CORE &" opj_dwt_getgain";
       when 148580  => report CORE &" opj_dwt_getnorm";
       when 148628  => report CORE &" opj_dwt_encode_real";
       when 149560  => report CORE &" opj_dwt_getgain_real";
       when 149568  => report CORE &" opj_dwt_getnorm_real";
       when 149616  => report CORE &" opj_dwt_calc_explicit_stepsizes";
       when 150128  => report CORE &" opj_dwt_decode_real";
       when 151460  => report CORE &" opj_procedure_list_create";
       when 151568  => report CORE &" opj_procedure_list_destroy";
       when 151640  => report CORE &" opj_procedure_list_add_procedure";
       when 151816  => report CORE &" opj_procedure_list_get_nb_procedures";
       when 151828  => report CORE &" opj_procedure_list_get_first_procedure";
       when 151840  => report CORE &" opj_procedure_list_clear";
       when 152324  => report CORE &" opj_t1_allocate_buffers";
       when 152652  => report CORE &" opj_t1_destroy";
       when 152800  => report CORE &" opj_t1_create";
       when 152924  => report CORE &" opj_t1_decode_cblks";
       when 162616  => report CORE &" opj_t1_encode_cblks";
       when 174060  => report CORE &" opj_t2_encode_packets";
       when 175300  => report CORE &" opj_t2_decode_packets";
       when 177572  => report CORE &" opj_t2_create";
       when 177644  => report CORE &" opj_t2_destroy";
       when 178032  => report CORE &" opj_mqc_create";
       when 178040  => report CORE &" opj_mqc_destroy";
       when 178064  => report CORE &" opj_mqc_numbytes";
       when 178080  => report CORE &" opj_mqc_init_enc";
       when 178144  => report CORE &" opj_mqc_encode";
       when 178344  => report CORE &" opj_mqc_flush";
       when 178476  => report CORE &" opj_mqc_bypass_init_enc";
       when 178492  => report CORE &" opj_mqc_bypass_enc";
       when 178596  => report CORE &" opj_mqc_bypass_flush_enc";
       when 178676  => report CORE &" opj_mqc_reset_enc";
       when 178748  => report CORE &" opj_mqc_restart_enc";
       when 178860  => report CORE &" opj_mqc_restart_init_enc";
       when 178932  => report CORE &" opj_mqc_erterm_enc";
       when 179076  => report CORE &" opj_mqc_segmark_enc";
       when 179156  => report CORE &" opj_mqc_init_dec";
       when 179408  => report CORE &" opj_mqc_decode";
       when 179968  => report CORE &" opj_mqc_resetstates";
       when 180008  => report CORE &" opj_mqc_setstate";
       when 180052  => report CORE &" opj_raw_create";
       when 180060  => report CORE &" opj_raw_destroy";
       when 180084  => report CORE &" opj_raw_numbytes";
       when 180136  => report CORE &" opj_raw_init_dec";
       when 180160  => report CORE &" opj_raw_decode";
       when 180324  => report CORE &" malloc";
       when 180360  => report CORE &" free";
       when 180456  => report CORE &" calloc";
       when 180508  => report CORE &" realloc";
       when 180576  => report CORE &" memalign";
       when 180668  => report CORE &" rand";
       when 180712  => report CORE &" srand";
       when 180744  => report CORE &" strtol";
       when 180788  => report CORE &" strtod";
       when 180832  => report CORE &" fopen";
       when 181012  => report CORE &" fscanf";
       when 181388  => report CORE &" putchar";
       when 181420  => report CORE &" sscanf";
       when 181456  => report CORE &" fread";
       when 181740  => report CORE &" fputc";
       when 181800  => report CORE &" getc";
       when 181860  => report CORE &" fseek";
       when 182068  => report CORE &" ftell";
       when 182080  => report CORE &" fclose";
       when 182148  => report CORE &" sprintf";
       when 182164  => report CORE &" vsnprintf";
       when 182220  => report CORE &" printf";
       when 182284  => report CORE &" fwrite";
       when 182476  => report CORE &" puts";
       when 182524  => report CORE &" fprintf";
       when 182908  => report CORE &" vsprintf";
       when 182916  => report CORE &" vfprintf";
       when 182960  => report CORE &" rename";
       when 183004  => report CORE &" snprintf";
       when 183052  => report CORE &" fseeko";
       when 183096  => report CORE &" ftello";
       when 183140  => report CORE &" fileno";
       when 183184  => report CORE &" fstat";
       when 183228  => report CORE &" assert";
       when 183236  => report CORE &" memcpy";
       when 183276  => report CORE &" memset";
       when 183316  => report CORE &" strlen";
       when 183376  => report CORE &" strchr";
       when 183428  => report CORE &" strcmp";
       when 183520  => report CORE &" strcpy";
       when 183556  => report CORE &" strstr";
       when 183688  => report CORE &" strncmp";
       when 183732  => report CORE &" strtok";
       when 183776  => report CORE &" strdup";
       when 183820  => report CORE &" strtok_r";
       when 183864  => report CORE &" strcspn";
       when 183908  => report CORE &" strspn";
       when 183952  => report CORE &" strcat";
       when 183996  => report CORE &" memmove";
       when 184040  => report CORE &" strpbrk";
       when 184084  => report CORE &" memcmp";
       when 184128  => report CORE &" __floatdisf";
       when 184160  => report CORE &" abs";
       when 184184  => report CORE &" fabs";
       when 184260  => report CORE &" floor";
       when 184396  => report CORE &" ceil";
       when 184516  => report CORE &" round";
       when 184576  => report CORE &" rint";
       when 184636  => report CORE &" lrintf";
       when 184700  => report CORE &" sqrt";
       when 185128  => report CORE &" pow";
       when 185332  => report CORE &" log";
       when 185376  => report CORE &" log2";
       when 185420  => report CORE &" log10";
       when 185464  => report CORE &" exp";
       when 185508  => report CORE &" log2f";
       when 185552  => report CORE &" sqrtf";
       when 185596  => report CORE &" powf";
       when 185640  => report CORE &" isfinite";
       when 185684  => report CORE &" va_start";
       when 185692  => report CORE &" va_end";
       when 185700  => report CORE &" sim_message";
       when 185724  => report CORE &" sim_stop";
       when 185736  => report CORE &" print_message";
       when 185764  => report CORE &" sim_finish";
       when 185776  => report CORE &" track_en";
       when 185788  => report CORE &" track_mark";
       when 185800  => report CORE &" __addsf3";
       when 187256  => report CORE &" __divsf3";
       when 188464  => report CORE &" __nesf2";
       when 188612  => report CORE &" __gtsf2";
       when 188872  => report CORE &" __lesf2";
       when 189132  => report CORE &" __mulsf3";
       when 190124  => report CORE &" __subsf3";
       when 191604  => report CORE &" __fixsfsi";
       when 191736  => report CORE &" __fixunssfsi";
       when 191856  => report CORE &" __floatsisf";
       when 192276  => report CORE &" __floatunsisf";
       when 192676  => report CORE &" __adddf3";
       when 195028  => report CORE &" __divdf3";
       when 197268  => report CORE &" __eqdf2";
       when 197444  => report CORE &" __gtdf2";
       when 197768  => report CORE &" __ltdf2";
       when 198092  => report CORE &" __muldf3";
       when 199724  => report CORE &" __subdf3";
       when 202116  => report CORE &" __fixdfsi";
       when 202252  => report CORE &" __fixunsdfsi";
       when 202388  => report CORE &" __floatsidf";
       when 202604  => report CORE &" __floatunsidf";
       when 202864  => report CORE &" __extendsfdf2";
       when 203240  => report CORE &" __truncdfsf2";
       when 203864  => report CORE &" __clzsi2";
       when others     => 
      end case;
    end if;
  end process;

end behav_functions;
