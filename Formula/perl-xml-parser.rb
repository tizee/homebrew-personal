class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "master"

  # use homebrew `perl` package
  depends_on "perl"

  def caveats
    if Formula["perl"].any_version_installed?
      <<~EOS
      perl-xml-parser has been install into:
        #{libexec}

      Add PERL5LIB to your shell configuration file:
      PERL5LIB=#{libexec}/lib/perl5

      EOS
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
    system "make", "install"
  end

  test do
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "#{Formula["perl"].bin}/perl", "-e", "require XML::Parser;"
  end
end
