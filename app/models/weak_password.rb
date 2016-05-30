class WeakPassword
  def self.instance
    'la ' +
      %w( fraise framboise pêche poire pomme
          banane mangue cerise tomate myrtille ).sample + ' ' +

      %w( délicieuse incroyable fantastique merveilleuse
          rouge jaune verte bleue orange mauve ).sample
  end
end
