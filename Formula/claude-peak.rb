class ClaudePeak < Formula
  desc "Claude Max subscription usage monitor for macOS menu bar"
  homepage "https://github.com/letsur-dev/claude-peak"
  url "https://github.com/letsur-dev/claude-peak.git", branch: "main"
  version "1.0.0"
  license "MIT"

  depends_on :macos
  depends_on xcode: ["15.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    app_name = "Claude Peak"
    app_bundle = prefix/"#{app_name}.app"

    (app_bundle/"Contents/MacOS").mkpath
    (app_bundle/"Contents/Resources").mkpath
    cp buildpath/".build/release/ClaudePeak", app_bundle/"Contents/MacOS/ClaudePeak"
    cp buildpath/"Resources/Info.plist", app_bundle/"Contents/Info.plist"
  end

  def post_install
    target = File.expand_path("~/Applications/Claude Peak.app")
    if File.exist?(target) || File.symlink?(target)
      FileUtils.rm_rf(target)
    end
    FileUtils.ln_sf("#{prefix}/Claude Peak.app", target)
  end

  def caveats
    <<~EOS
      Claude Peak has been installed and linked to ~/Applications/.
      Run with:
        open ~/Applications/Claude\\ Peak.app

      First launch requires OAuth login via browser.
    EOS
  end
end
