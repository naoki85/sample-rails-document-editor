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

  def edit
    @uploaded_file = UploadedFile.find(params[:id])
    @content = File.read(@uploaded_file.file_path)
  end

  def update
    @uploaded_file = UploadedFile.find(params[:id])
    pp uploaded_file_edit_params[:content]
    split_file_path = @uploaded_file.file_path.split('.')
    split_file_path[0] = split_file_path[0] + "-#{Time.new.to_i}"
    new_file_path = split_file_path.join(".")
    File.open(new_file_path, 'wb') do |file|
      file.write(uploaded_file_edit_params[:content])
    end

    @uploaded_file.file_path = new_file_path
    @uploaded_file.save
    redirect_to edit_uploaded_file_path(@uploaded_file.id)
  end

  def download
    @uploaded_file = UploadedFile.find(params[:id])
    if File.exist?(@uploaded_file.file_path)
      send_file @uploaded_file.file_path, x_sendfile: true
    else
      head :not_found
    end
  end

  private

  def text_file_params
    params.require(:uploaded_file).permit(:file)
  end

  def uploaded_file_edit_params
    params.require(:uploaded_file).permit(:content)
  end
end
