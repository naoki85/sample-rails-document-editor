class WorkDocsClient
  REGION = 'ap-northeast-1'

  def initialize
    @client = Aws::WorkDocs::Client.new(region: REGION)
    @organization_id = ENV["AWS_WORKDOCS_ORGANIZATION_ID"]
    @user_email = ENV["AWS_WORKDOCS_USER_EMAIL"]
  end

  def upload_file(file_name, file_path)
    parent_folder_id = get_user_root_folder_id

    # WorkDocsにアップロード用のURLを取得
    response = @client.initiate_document_version_upload(
      name: file_name,
      parent_folder_id: parent_folder_id,
      content_type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    )

    upload_url = response.upload_metadata.upload_url
    document_id = response.metadata.id
    document_version_id = response.metadata.latest_version_metadata.id
    upload(upload_url, file_path, response.upload_metadata.signed_headers)
    @client.update_document_version(
      document_id: document_id,
      version_id: document_version_id,
      version_status: 'ACTIVE'
    )
  end

  def get_user_root_folder_id
    root_folder_id = ""
    resp = @client.describe_users({ organization_id: @organization_id })

    resp.users.each do |user|
      if user.email_address == @user_email
        root_folder_id = user.root_folder_id
        break
      end
    end

    root_folder_id
  end

  private

  def upload(upload_url, file_path, signed_headers)
    uri = URI(upload_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Put.new(uri.request_uri)
    response = nil

    File.open(file_path, 'rb') do |file|
      request.body_stream = file
      signed_headers.each do |k, v|
        request[k.to_s] = v
      end
      request['Content-Length'] = file.size
      response = http.request(request)
    end

    if !response or response.code != 200
      raise("upload failed")
    end

    response
  end
end
