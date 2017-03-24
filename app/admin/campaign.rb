ActiveAdmin.register Campaign do
  permit_params :partner, :standard_price, :premium_price, :campaign_url
end
