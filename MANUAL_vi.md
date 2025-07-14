# Hướng dẫn sử dụng hệ thống tự host

Chào mừng bạn đến với hướng dẫn sử dụng hệ thống tự host của bạn. Tài liệu này sẽ giúp bạn hiểu và vận hành các dịch vụ đã được triển khai trên hệ thống của mình.

## 1. Giới thiệu hệ thống

Hệ thống này được thiết lập để chạy nhiều ứng dụng và dịch vụ khác nhau trên máy chủ của bạn bằng cách sử dụng Docker và Docker Compose. Điều này giúp việc quản lý, cập nhật và sao lưu các ứng dụng trở nên dễ dàng hơn.

Các dịch vụ chính bao gồm:
*   **AdGuard Home:** Chặn quảng cáo và theo dõi trên toàn mạng.
*   **Filebrowser:** Giao diện web để quản lý tệp trên máy chủ.
*   **Homepage:** Trang chủ tùy chỉnh để truy cập nhanh các dịch vụ của bạn.
*   **Immich:** Giải pháp thay thế Google Photos tự host.
*   **Nextcloud:** Đám mây cá nhân để lưu trữ tệp, đồng bộ hóa và chia sẻ.
*   **NPM (Nginx Proxy Manager):** Quản lý proxy ngược với giao diện web dễ sử dụng, bao gồm cấp chứng chỉ SSL miễn phí từ Let's Encrypt.
*   **Paperless-ngx:** Hệ thống quản lý tài liệu không giấy tờ.
*   **Portainer:** Giao diện người dùng đồ họa để quản lý Docker containers, images, volumes và networks.
*   **Uptime Kuma:** Công cụ giám sát thời gian hoạt động (uptime) cho các dịch vụ của bạn.
*   **Vaultwarden:** Máy chủ tương thích với Bitwarden để quản lý mật khẩu.

## 2. Yêu cầu hệ thống (Prerequisites)

Để vận hành hệ thống này, bạn cần có:
*   **Docker:** Nền tảng container hóa.
*   **Docker Compose:** Công cụ để định nghĩa và chạy các ứng dụng Docker đa container.
*   **Git:** Để sao chép kho lưu trữ này (nếu bạn chưa làm).
*   **Quyền truy cập SSH/Terminal** vào máy chủ Linux của bạn.

## 3. Cài đặt và Thiết lập ban đầu

Các bước sau đây giả định bạn đã sao chép kho lưu trữ này vào máy chủ của mình.

1.  **Điều hướng đến thư mục dự án:**
    ```bash
    cd /home/shin/selfhost
    ```

2.  **Kiểm tra và chỉnh sửa cấu hình (nếu cần):**
    Các tệp cấu hình chính nằm trong thư mục gốc:
    *   `docker-compose.yml`: Định nghĩa các dịch vụ Docker.
    *   `apps.yml`: Cấu hình cho các ứng dụng cụ thể (ví dụ: Homepage).
    *   `proxy.yml`: Cấu hình liên quan đến Nginx Proxy Manager.
    *   `monitoring.yml`: Cấu hình cho các dịch vụ giám sát (ví dụ: Netdata).

    Bạn có thể cần chỉnh sửa các tệp này để phù hợp với tên miền, cổng hoặc các cài đặt khác của mình.

3.  **Khởi tạo cơ sở dữ liệu (nếu có):**
    Một số dịch vụ có thể yêu cầu khởi tạo cơ sở dữ liệu ban đầu. Tệp `init-db.sh` có thể chứa các lệnh cần thiết cho việc này. Hãy kiểm tra nội dung của nó:
    ```bash
    cat init-db.sh
    ```
    Và chạy nó nếu cần:
    ```bash
    ./init-db.sh
    ```

4.  **Khởi động các dịch vụ:**
    Sử dụng tập lệnh `compose.sh` để quản lý các dịch vụ Docker Compose. Tập lệnh này có thể có các tùy chọn khác nhau (ví dụ: `up`, `down`, `pull`).
    Để khởi động tất cả các dịch vụ ở chế độ nền:
    ```bash
    ./compose.sh up -d
    ```
    Nếu bạn muốn xem nhật ký trong quá trình khởi động, hãy bỏ `-d`.

5.  **Kiểm tra trạng thái dịch vụ:**
    Sau khi khởi động, bạn có thể kiểm tra trạng thái của các container:
    ```bash
    docker ps
    ```

## 4. Truy cập các ứng dụng

Sau khi các dịch vụ đã chạy, bạn có thể truy cập chúng qua trình duyệt web. Các cổng và tên miền cụ thể sẽ phụ thuộc vào cấu hình của bạn trong `docker-compose.yml` và `proxy.yml`.

*   **Homepage:** Thường có thể truy cập qua cổng 80 hoặc 443 nếu bạn đã cấu hình proxy ngược.
*   **Nginx Proxy Manager:** Thường có giao diện quản trị trên một cổng cụ thể (ví dụ: 81). Kiểm tra `docker-compose.yml` để biết chi tiết.
*   **Portainer:** Tương tự, Portainer cũng có giao diện quản trị web trên một cổng riêng.

**Lưu ý quan trọng:** Hãy đảm bảo bạn đã cấu hình đúng các bản ghi DNS cho tên miền của mình trỏ về địa chỉ IP của máy chủ.

## 5. Các tác vụ quản lý phổ biến

*   **Dừng tất cả các dịch vụ:**
    ```bash
    ./compose.sh down
    ```

*   **Khởi động lại tất cả các dịch vụ:**
    ```bash
    ./compose.sh restart
    ```

*   **Cập nhật các dịch vụ (kéo hình ảnh Docker mới nhất):**
    ```bash
    ./compose.sh pull
    ./compose.sh up -d
    ```

*   **Xem nhật ký của một dịch vụ cụ thể (ví dụ: homepage):**
    ```bash
    docker logs homepage
    ```
    (Thay `homepage` bằng tên dịch vụ bạn muốn xem nhật ký).

*   **Sao lưu dữ liệu:**
    Thư mục `data/` chứa tất cả dữ liệu liên tục của các ứng dụng. Để sao lưu, bạn nên dừng các dịch vụ trước, sau đó sao chép thư mục `data/` đến một vị trí an toàn.
    ```bash
    ./compose.sh down
    cp -r data/ /path/to/your/backup/location/
    ./compose.sh up -d
    ```

*   **Khắc phục sự cố:**
    *   Kiểm tra nhật ký của các container bị lỗi (`docker logs <container_name>`).
    *   Đảm bảo các cổng không bị xung đột.
    *   Kiểm tra cấu hình trong các tệp `.yml` của bạn.

## 6. Cấu trúc thư mục dữ liệu

Thư mục `data/` chứa dữ liệu cho từng ứng dụng, ví dụ:
*   `data/adguard/`
*   `data/filebrowser/`
*   `data/homepage/`
*   `data/immich_postgres/`
*   `data/immich_upload/`
*   `data/immich-model-cache/`
*   `data/netdata/`
*   `data/nextcloud/`
*   `data/npm/`
*   `data/paperless/`
*   `data/portainer/`
*   `data/postgres/`
*   `data/uptime-kuma/`
*   `data/vaultwarden/`

Thư mục `media/paperless/` chứa các tệp liên quan đến Paperless-ngx:
*   `media/paperless/consume/`: Nơi bạn đặt tài liệu để Paperless xử lý.
*   `media/paperless/export/`: Nơi xuất tài liệu đã xử lý.
*   `media/paperless/media/documents/originals/`: Tài liệu gốc.
*   `media/paperless/media/documents/thumbnails/`: Hình thu nhỏ của tài liệu.

Hy vọng hướng dẫn này hữu ích cho bạn!
