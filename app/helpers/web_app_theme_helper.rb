module WebAppThemeHelper

  def self.prepare
    FileUtils.rm_rf(File.expand_path('public/dormouse', Rails.root))
    FileUtils.cp_r(File.expand_path('../../views/web_app_theme/assets', __FILE__),
                   File.expand_path('public/dormouse', Rails.root))
  end

  def active_class(base)
    'active' if request.path.starts_with?(base)
  end

end