require 'rubygems'
require 'mechanize'

class Hash

  def strip
    self.each_with_object({}) do |(k, v), hash|
      if v.respond_to?(:strip)
        hash[k] = v.strip 
      else
        hash[k] = v
      end
    end
  end

end

module CRTM

  class CRTMMechanizer

    def self.get_card_details(id, number)
      agent = Mechanize.new
      crtm = agent.get('http://www.tarjetatransportepublico.es/CRTM-ABONOS/consultaSaldo.aspx')
      crtm.form_with(:name => 'aspnetForm').field_with(:name => 'ctl00$cntPh$txtNumTTP').value = number
      crtm.form_with(:name => 'aspnetForm').field_with(:name => 'ctl00$cntPh$dpdCodigoTTP').value = id
      page = crtm.form_with(:name => 'aspnetForm').click_button

      {
        :card_no => page.search("#ctl00_cntPh_lblNumeroTarjeta").text,
        :subscription_type => page.search("#ctl00_cntPh_tableResultados span")[0].text,
        :subscription_age => page.search("#ctl00_cntPh_tableResultados span")[1].text,
        :load_date => Date.parse(page.search("#ctl00_cntPh_tableResultados span")[2].text),
        :valid_date => Date.parse(page.search("#ctl00_cntPh_tableResultados span")[3].text),
        :first_use => Date.parse(page.search("#ctl00_cntPh_tableResultados span")[4].text),
        :renovation_date => Date.parse(page.search("#ctl00_cntPh_tableResultados span")[5].text)
      }.strip

    end

  end

end