require 'base64'

module D2S3
  module ViewHelpers
    include D2S3::Signature

    def s3_http_upload_tag(options = {})
      bucket          = D2S3::S3Config.bucket
      access_key_id   = D2S3::S3Config.access_key_id
      key             = options[:key] || ''
      content_type    = options[:content_type] || '' # Defaults to binary/octet-stream if blank
      redirect        = options[:redirect] || '/'
      acl             = options[:acl] || 'public-read'
      expiration_date = (options[:expiration_date] || 10.hours).from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
      max_filesize    = options[:max_filesize] || 1.megabyte
      min_filesize    = options[:min_filesize] || 1.byte
      submit_button   = options[:submit_button] || submit_tag('Upload')
      
      options[:form] ||= {}
      options[:form][:id] ||= 'upload-form'
      options[:form][:class] ||= 'upload-form'

      policy = Base64.encode64(
        "{'expiration': '#{expiration_date}',
          'conditions': [
            {'bucket': '#{bucket}'},
            ['starts-with', '$key', '#{key}'],
            {'acl': '#{acl}'},
            {'success_action_redirect': '#{redirect}'},
            ['starts-with', '$Content-Type', '#{content_type}'],
            ['content-length-range', #{min_filesize}, #{max_filesize}]
          ]
        }").gsub(/\n|\r/, '')

      signature = b64_hmac_sha1(D2S3::S3Config.secret_access_key, policy)
      content_tag :form, options[:form].merge(:action => "https://#{bucket}.s3.amazonaws.com/", :method => 'POST', :enctype => 'multipart/form-data') do
        hidden_field_tag('key', "#{key}/${filename}") +
        hidden_field_tag('AWSAccessKeyId', access_key_id) +
        hidden_field_tag('acl', acl) +
        hidden_field_tag('success_action_redirect', redirect) +
        hidden_field_tag('policy', policy) +
        hidden_field_tag('signature', signature) +
        hidden_field_tag('Content-Type', content_type) +
        file_field_tag('file') +
        submit_button
      end
    end
  end
end

ActionView::Base.send(:include, D2S3::ViewHelpers)
