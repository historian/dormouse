module BloxHelper

  def self.prepare
    FileUtils.rm_rf(File.expand_path('public/dormouse', Rails.root))
    FileUtils.ln_s(File.expand_path('../../views/blox/assets', __FILE__),
                   File.expand_path('public/dormouse', Rails.root))
  end

end