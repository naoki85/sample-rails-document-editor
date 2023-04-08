class UploadedFileController < ApplicationController
  def create
    upload_file = text_file_params[:file]
    upload_dir = "/tmp/#{Time.new.to_i}"
    FileUtils.mkdir_p(upload_dir)
    destination = File.join(upload_dir, text_file_params[:file].original_filename)
    FileUtils.mv(text_file_params[:file].tempfile, File.join(upload_dir, text_file_params[:file].original_filename))
    uploaded_file = UploadedFile.new({file_type: "txt", file_name: upload_file.original_filename, file_path: destination})
    uploaded_file.save
    redirect_to root_path
  end

  private

  def text_file_params
    params.require(:uploaded_file).permit(:file)
  end
end
