class UploadedFileController < ApplicationController
  before_action :find_uploaded_file, only: [:edit, :update, :download]
  def create
    upload_file_param = upload_file_params[:file]
    uploaded_file = UploadedFile.new(UploadedFile.parse_from_upload_file(upload_file_param))
    if uploaded_file[:file_type] != 'txt'
      workdocs = WorkDocsClient.new
      workdocs.upload_file(uploaded_file[:file_name], uploaded_file[:file_path])
    end
    uploaded_file.save
    redirect_to root_path
  end

  def edit
    @content = File.read(@uploaded_file.file_path)
  end

  def update
    @uploaded_file.set_new_file_path!
    File.open(@uploaded_file.file_path, 'wb') do |file|
      file.write(uploaded_file_edit_params[:content])
    end
    @uploaded_file.save
    redirect_to edit_uploaded_file_path(@uploaded_file.id)
  end

  def download
    if File.exist?(@uploaded_file.file_path)
      send_file @uploaded_file.file_path, x_sendfile: true
    else
      head :not_found
    end
  end

  private

  def upload_file_params
    params.require(:uploaded_file).permit(:file)
  end

  def uploaded_file_edit_params
    params.require(:uploaded_file).permit(:content)
  end

  def find_uploaded_file
    @uploaded_file = UploadedFile.find(params[:id])
  end
end
