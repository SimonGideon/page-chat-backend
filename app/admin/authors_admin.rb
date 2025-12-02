Trestle.resource(:authors) do
  menu do
    item :authors, icon: "fa fa-pen-nib", group: :library
  end

  table do
    column :name
    column :email
    column :website
    column :social_handle, -> (author) do
      handles = author.social_handles
      if handles.any?
        handles.map { |h| "#{h[:platform]&.capitalize}: #{h[:url]}" }.join(", ")
      else
        "N/A"
      end
    end
    column :created_at, align: :center
    actions
  end

  form do |author|
    text_field :name
    text_field :email
    text_area :biography, rows: 4
    text_field :website
    
    # Social handles section
    placeholders_hash = {
      twitter: "https://twitter.com/username or https://x.com/username",
      facebook: "https://facebook.com/username",
      instagram: "https://instagram.com/username",
      linkedin: "https://linkedin.com/in/username",
      youtube: "https://youtube.com/@username or https://youtube.com/c/channelname",
      tiktok: "https://tiktok.com/@username",
      pinterest: "https://pinterest.com/username",
      snapchat: "https://snapchat.com/add/username",
      reddit: "https://reddit.com/user/username",
      github: "https://github.com/username",
      medium: "https://medium.com/@username",
      goodreads: "https://goodreads.com/author/show/authorid"
    }
    
    handles = author.social_handles
    handles = [{}] if handles.empty?
    
    concat raw('<div class="form-group">')
    concat raw('<label class="control-label">Social Media Handles</label>')
    concat raw('<button type="button" class="btn btn-sm btn-primary mb-2" id="add-social-handle" style="margin-left: 10px;">Add Social Media</button>')
    concat raw('<div id="social-handles-container" class="social-handles-list">')
    
    handles.each_with_index do |handle, index|
      platform = handle[:platform] rescue nil
      url = handle[:url] rescue nil
      placeholder = platform.present? ? placeholders_hash[platform.to_sym] : "https://twitter.com/username"
      
      concat raw('<div class="social-handle-item mb-2" style="display: flex; gap: 10px; align-items: flex-end;" data-index="' + index.to_s + '">')
      concat raw('<div style="flex: 1;">')
      concat select_tag("author[social_handles][#{index}][platform]", 
        options_for_select([
          ["Select a platform", ""],
          ["Twitter/X", "twitter"],
          ["Facebook", "facebook"],
          ["Instagram", "instagram"],
          ["LinkedIn", "linkedin"],
          ["YouTube", "youtube"],
          ["TikTok", "tiktok"],
          ["Pinterest", "pinterest"],
          ["Snapchat", "snapchat"],
          ["Reddit", "reddit"],
          ["GitHub", "github"],
          ["Medium", "medium"],
          ["Goodreads", "goodreads"]
        ], platform),
        { 
          class: "form-control social-platform-select", 
          data: { placeholders: placeholders_hash.to_json }
        }
      )
      concat raw('</div>')
      concat raw('<div style="flex: 2;">')
      concat text_field_tag("author[social_handles][#{index}][url]", url, 
        { 
          class: "form-control social-url-input",
          placeholder: placeholder
        }
      )
      concat raw('</div>')
      concat raw('<button type="button" class="btn btn-sm btn-danger remove-social-handle" style="display: ' + (handles.length > 1 ? 'block' : 'none') + ';">Remove</button>')
      concat raw('</div>')
    end
    
    concat raw('</div>')
    concat raw('</div>')

    file_field :avatar
    if author.avatar.attached?
      concat content_tag(:div, class: "mt-2") do
        content_tag(:span, "Current avatar: #{author.avatar.filename}")
      end
    end
    
    # JavaScript for dynamic social handles
    concat content_tag(:script, raw(<<-JS
      (function() {
        var container = document.getElementById('social-handles-container');
        var addButton = document.getElementById('add-social-handle');
        var placeholders = {
          twitter: "https://twitter.com/username or https://x.com/username",
          facebook: "https://facebook.com/username",
          instagram: "https://instagram.com/username",
          linkedin: "https://linkedin.com/in/username",
          youtube: "https://youtube.com/@username or https://youtube.com/c/channelname",
          tiktok: "https://tiktok.com/@username",
          pinterest: "https://pinterest.com/username",
          snapchat: "https://snapchat.com/add/username",
          reddit: "https://reddit.com/user/username",
          github: "https://github.com/username",
          medium: "https://medium.com/@username",
          goodreads: "https://goodreads.com/author/show/authorid"
        };
        
        function updatePlaceholder(select, input) {
          var platform = select.value;
          if (platform && placeholders[platform]) {
            input.placeholder = placeholders[platform];
          } else {
            input.placeholder = 'Enter social media URL';
          }
        }
        
        function createSocialHandleField(index) {
          var div = document.createElement('div');
          div.className = 'social-handle-item mb-2';
          div.style.cssText = 'display: flex; gap: 10px; align-items: flex-end;';
          div.setAttribute('data-index', index);
          
          var platformOptions = '<option value="">Select a platform</option>' +
            '<option value="twitter">Twitter/X</option>' +
            '<option value="facebook">Facebook</option>' +
            '<option value="instagram">Instagram</option>' +
            '<option value="linkedin">LinkedIn</option>' +
            '<option value="youtube">YouTube</option>' +
            '<option value="tiktok">TikTok</option>' +
            '<option value="pinterest">Pinterest</option>' +
            '<option value="snapchat">Snapchat</option>' +
            '<option value="reddit">Reddit</option>' +
            '<option value="github">GitHub</option>' +
            '<option value="medium">Medium</option>' +
            '<option value="goodreads">Goodreads</option>';
          
          div.innerHTML = 
            '<div style="flex: 1;"><select name="author[social_handles][' + index + '][platform]" class="form-control social-platform-select">' + platformOptions + '</select></div>' +
            '<div style="flex: 2;"><input type="text" name="author[social_handles][' + index + '][url]" class="form-control social-url-input" placeholder="Enter social media URL" /></div>' +
            '<button type="button" class="btn btn-sm btn-danger remove-social-handle">Remove</button>';
          
          var select = div.querySelector('.social-platform-select');
          var input = div.querySelector('.social-url-input');
          
          select.addEventListener('change', function() {
            updatePlaceholder(select, input);
          });
          
          div.querySelector('.remove-social-handle').addEventListener('click', function() {
            div.remove();
            updateRemoveButtons();
          });
          
          return div;
        }
        
        function updateRemoveButtons() {
          var items = container.querySelectorAll('.social-handle-item');
          items.forEach(function(item, index) {
            var removeBtn = item.querySelector('.remove-social-handle');
            if (items.length > 1) {
              removeBtn.style.display = 'block';
            } else {
              removeBtn.style.display = 'none';
            }
          });
        }
        
        if (addButton && container) {
          addButton.addEventListener('click', function() {
            var items = container.querySelectorAll('.social-handle-item');
            var newIndex = items.length;
            var newField = createSocialHandleField(newIndex);
            container.appendChild(newField);
            updateRemoveButtons();
          });
          
          // Handle existing remove buttons
          container.addEventListener('click', function(e) {
            if (e.target.classList.contains('remove-social-handle')) {
              e.target.closest('.social-handle-item').remove();
              updateRemoveButtons();
            }
          });
          
          // Handle existing platform selects
          container.addEventListener('change', function(e) {
            if (e.target.classList.contains('social-platform-select')) {
              var input = e.target.closest('.social-handle-item').querySelector('.social-url-input');
              updatePlaceholder(e.target, input);
            }
          });
        }
      })();
    JS
    ), type: "text/javascript")
  end

  params do |params|
    author_params = params.require(:author).permit(:name, :email, :biography, :website, :avatar, social_handles: [:platform, :url])
    
    # Process social handles array
    if author_params[:social_handles].present?
      handles = author_params[:social_handles].values.select { |h| h[:platform].present? && h[:url].present? }
      if handles.any?
        author_params[:social_handle] = handles.map { |h| { platform: h[:platform], url: h[:url] } }.to_json
      else
        author_params[:social_handle] = nil
      end
    else
      author_params[:social_handle] = nil
    end
    
    # Remove the temporary field
    author_params.delete(:social_handles)
    
    author_params
  end
end

