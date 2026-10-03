#!/bin/bash

echo "------------------------------------------------"
echo "Đang chuẩn bị dọn dẹp và khởi động lại MySQL..."
echo "------------------------------------------------"

# 1. Thử tắt MySQL một cách an toàn trước
# Lưu ý: Bạn sẽ phải nhập mật khẩu root của MySQL tại đây
echo "Yêu cầu MySQL đóng các kết nối an toàn (Nhập mật khẩu OS, sau đó root mySQL):"
sudo /usr/local/mysql/bin/mysqladmin -u root -p shutdown

# 2. Xử lý các tiến trình bị treo nếu lệnh shutdown ở trên không thành công
echo "Đang quét sạch các tiến trình còn sót lại..."
sudo killall -9 mysqld 2>/dev/null

# 3. Dọn dẹp file rác
echo "Đang dọn dẹp file PID và Socket cũ..."
sudo rm -rf /usr/local/mysql/data/*.pid
sudo rm -rf /tmp/mysql.sock

# 4. Sửa lại quyền sở hữu thư mục data
sudo chown -R _mysql:wheel /usr/local/mysql/data

# 5. Khởi động lại MySQL ở chế độ an toàn
echo "Đang khởi chạy MySQL Server..."
sudo /usr/local/mysql/bin/mysqld_safe --user=_mysql > /dev/null 2>&1 &

# Đợi một chút để hệ thống tạo socket
sleep 5

# 6. Kiểm tra kết quả
echo "------------------------------------------------"
echo "Kiểm tra socket:"
if [ -S /tmp/mysql.sock ]; then
    ls -la /tmp/mysql.sock
    echo "THÀNH CÔNG: MySQL đã sẵn sàng!"
else
    echo "CẢNH BÁO: Không tìm thấy socket. Vui lòng kiểm tra lại log lỗi."
fi
echo "------------------------------------------------"