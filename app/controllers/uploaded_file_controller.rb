class UploadedFileController < ApplicationController
  before_action :find_uploaded_file, only: [:edit, :update, :download, :prepare_workdocs, :show_workdocs_link]
  def create
    upload_file_param = upload_file_params[:file]
    uploaded_file = UploadedFile.new(UploadedFile.parse_from_upload_file(upload_file_param))
    if uploaded_file[:file_type] != 'txt'
      workdocs = WorkDocsClient.new
      res = workdocs.upload_file(uploaded_file[:file_name], uploaded_file[:file_path], uploaded_file[:file_type])
      uploaded_file.workdocs_document_id = res[:document_id]
      uploaded_file.workdocs_document_version_id = res[:document_version_id]
    end
    uploaded_file.save
    redirect_to root_path
  end

  def edit
    @content = File.read(@uploaded_file.file_path)
  end

  def prepare_workdocs
    # TODO: ユーザーを作成する
    user_id = ENV['AWS_WORKDOCS_SHARED_USER_ID']
    workdocs = WorkDocsClient.new
    workdocs.add_resource_permissions(@uploaded_file.workdocs_document_id, user_id)
    redirect_to show_workdocs_link_uploaded_file_path(@uploaded_file.id)
  end

  def show_workdocs_link
    @workdocs_link = "https://#{ENV['AWS_WORKDOCS_WORKSPACE_NAME']}.awsapps.com/workdocs/index.html#/document/#{@uploaded_file.workdocs_document_id}"
    # TODO: ユーザーに紐づく、 WorkDocs ユーザーを応答する
    @shared_user = ENV['AWS_WORKDOCS_SHARED_USER']
    @shared_user_email = ENV['AWS_WORKDOCS_SHARED_USER_EMAIL']
    @shared_user_password = ENV['AWS_WORKDOCS_SHARED_USER_PASSWORD']
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
    if @uploaded_file.file_type != "txt"
      workdocs = WorkDocsClient.new
      workdocs.download_file(@uploaded_file.workdocs_document_id, @uploaded_file.workdocs_document_version_id, @uploaded_file.file_path)
    end

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
