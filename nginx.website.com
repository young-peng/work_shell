limit_req_zone $remote_addr zone=allips:20m rate=12000r/m;
proxy_temp_path             /etc/nginx/tmp;
proxy_cache_path            /etc/nginx/cache    levels=1:2 keys_zone=cache_one:500m inactive=1d max_size=1g;

upstream api {
    server                  server address weight=4;
    server                  server address weight=4;
    server                  server address weight=4;
    server                  server address weight=4;
    server                  server address weight=4;
    server                  server address weight=4 backup;
    server                  server address weight=4 backup;
    server                  server address weight=4 backup;
    server                  server address weight=4 backup;
}

server {
    listen                  80;
    server_name             server_name;
    server_name             server_name;

    limit_req zone=allips burst=10 nodelay;

    charset                 utf-8;

    proxy_set_header        X-Real-IP      $remote_addr;
    proxy_set_header        X-Forwarded-For $remote_addr;
    proxy_ignore_headers    X-Accel-Expires Expires Cache-Control;
    proxy_cache_use_stale   updating;
    proxy_cache_lock        on;
    proxy_next_upstream error timeout http_502;
    add_header              X-Proxy-Cache $upstream_cache_status;

    access_log              /data/deploy/logs/nginx/access-out.log access;
    error_log               /data/deploy/logs/nginx/error.log;
    set $cache_key "$host$server_port$uri?page_size=$arg_page_size&page_no=$arg_page_no&type=$arg_type&area=$arg_area&year=$arg_year&order_by=$arg_order_by&label_id=$arg_label_id&category_id=$arg_category_id&show_top_recommend=$arg_show_top_recommend&vip_type=$arg_vip_type&channel=$arg_channel&age=$arg_age&actors=$arg_actors&presenter=$arg_presenter&no_vip_type=$arg_no_vip_type&version_code=$arg_version_code&mobile=$arg_mobile&togic_tag=$arg_togic_tag&title=$arg_title&spec_title=$arg_spec_title";
    location / {
       proxy_pass           http://api;
    }
    location /api/cluster/history_guess {
         return 404;
    } 
    location  /api/v1/channels {
       proxy_cache          cache_one;
       proxy_cache_key      "$host$server_port$uri?province=$arg_province&isbinding=$arg_isbinding&isp=$arg_isp&show_nba=$arg_show_nba";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
    }

    location  /api/v1/channel_type.json {
       proxy_cache          cache_one;
       proxy_cache_key      "$host$server_port$uri?province=$arg_province&isp=$arg_isp&isbinding=$arg_isbinding";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
    }

    location  /api/v1/program_info {
       proxy_cache          cache_one;
       proxy_cache_key      "$host$server_port$uri?category_id=$arg_category_id&program_id=$arg_program_id&episode_page_no=$arg_episode_page_no&episode_page_size=$arg_episode_page_size&title=$arg_title&zone_category_id=$arg_zone_category_id&action=$arg_action&sort=$arg_sort&version_code=$arg_version_code";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
    }


    location  /api/v1/hot {
       proxy_cache          cache_one;
       proxy_cache_key      "$host$server_port$uri";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
    }

    location  /api/v1/recommend_subject {
       proxy_cache          cache_one;
       proxy_cache_key      "$host$server_port$uri?id=$arg_id";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
    }

    location  /api/v1/recommend {
       proxy_cache          cache_one;
       proxy_cache_methods GET HEAD POST;
       proxy_cache_key      "$host$server_port$uri?page_size=$arg_page_size&program_id=$arg_program_id";
       proxy_cache_valid    200 304 302 405 1h;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
    }

    location  /api/v1/programs_label {
       proxy_cache          cache_one;
       proxy_cache_key      "$host$server_port$uri?category_id=$arg_category_id&version_code=$arg_version_code";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
    }

    location  /api/v1/top_recommend {
       proxy_cache          cache_one;
       proxy_cache_key      "$host$server_port$uri?category_id=$arg_category_id&new_user=$arg_new_user&version_code=$arg_version_code";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
    }

    location  /api/v1/live_programs {
       proxy_cache          cache_one;
       proxy_cache_key      "$host$server_port$uri?page_size=$arg_page_size&page_no=$arg_page_no&version_code=$arg_version_code&show_vip=$arg_show_vip&show_nba=$arg_show_nba";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
    }

    location  /api/v1/live_program {
       proxy_cache          cache_one;
       proxy_cache_key      "$host$server_port$uri?program_id=$arg_program_id";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
    }

    location  /api/v1/live_program_detail {
       proxy_cache          cache_one;
       proxy_cache_key      "$host$server_port$uri?pid=$arg_pid";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
    }

    location = /api/v1/programs {
       proxy_set_header "Content-Type" "application/json";
       #if ($arg_city = "%E6%B7%B1%E5%9C%B3") {
       #    proxy_pass       http://recommend_api;
       #    break;
       #}
       #if ($use_custom_recommend_api) {
       #    proxy_pass       http://recommend_api;
       #    break;
       #}
       if ($arg_category_id = "2") {
            set $cache_key "$host$server_port$uri?page_size=$arg_page_size&page_no=$arg_page_no&type=$arg_type&area=$arg_area&year=$arg_year&order_by=$arg_order_by&label_id=$arg_label_id&category_id=$arg_category_id&show_top_recommend=$arg_show_top_recommend&vip_type=$arg_vip_type&channel=$arg_channel&age=$arg_age&actors=$arg_actors&presenter=$arg_presenter&no_vip_type=$arg_no_vip_type&version_code=$arg_version_code&mobile=$arg_mobile&device_id=$arg_device_id&togic_tag=$arg_togic_tag&title=$arg_title&spec_title=$arg_spec_title";
       }
       proxy_cache          cache_one;
       proxy_cache_key      $cache_key; 
       proxy_cache_valid    200 304 302 405 1m;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
    }

   location  /api/v1/actor_info {
     proxy_set_header "Content-Type" "application/json";
     proxy_cache          cache_one;
     proxy_cache_methods GET HEAD POST;
     proxy_cache_key      "$host$server_port$uri?device_id=$arg_device_id&version_code=$arg_version_code&model=$arg_model&actors=$arg_actors";
     proxy_cache_valid    200 304 302 405 1m;
     proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
     proxy_pass           http://api;
    }
    location  /api/v1/third_party_apps {
       proxy_cache          cache_one;
       proxy_cache_key      "$host$server_port$uri?type=$arg_type&channel=$arg_channel";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
       proxy_pass           http://api;
       add_header "Access-Control-Allow-Origin" "*";
    }

    location  /api/layout/cell_update {
       proxy_cache          cache_one;
       proxy_cache_methods GET HEAD POST;
       proxy_cache_key      "$host$server_port$uri?id=$arg_id&show_nba=$arg_show_nba";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_pass           http://api;
    }

    location  /api/v1/filter {
       proxy_cache          cache_one;
       proxy_cache_methods GET HEAD POST;
       proxy_cache_key      "$host$server_port$uri?category_id=$arg_category_id";
       proxy_cache_valid    200 304 302 405 1m;
       proxy_pass           http://api;
    }
}

map $arg_device_id $use_custom_recommend_api {
    default                                             '0';
}
