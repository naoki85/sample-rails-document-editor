class UploadedFile < ApplicationRecord
  UPLOAD_FILE_BASE_PATH = "/tmp"

  # 新しいファイルパスをセットする
  # 例: 元々が /tmp/xxxxxx/test.txt だった場合、
  # /tmp/xxxxxx/test-yyyyyy.txt に変更する
  def set_new_file_path!
    arr_base_file_name = self.file_name.split('.')
    old_base_file_name = arr_base_file_name[0..-2].join('.')
    ext = arr_base_file_name[-1]
    split_file_path = self.file_path.split('/')[0..-2]
    new_file_name = old_base_file_name + "-#{Time.new.to_i}"
    new_file_path = split_file_path.join("/") + "/" + new_file_name + ".#{ext}"
    self.file_path = new_file_path
  end

  class << self
    def move_tempfile(upload_file)
      upload_dir = "#{UPLOAD_FILE_BASE_PATH}/#{Time.new.to_i}"
      FileUtils.mkdir_p(upload_dir)
      destination = File.join(upload_dir, upload_file.original_filename)
      FileUtils.mv(upload_file.tempfile, destination)
      destination
    end
  end
end
