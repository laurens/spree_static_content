class Spree::StaticPage
  def self.ensure_slug_prefix(slug)
    slug.start_with?('/') ? slug : "/#{slug}"
  end

  def self.matches?(request)
    slug = request.symbolized_path_parameters[:slug]
    
    # required or ActsAsTenant will confuse this by injecting the wrong tenant in some circumstances
    # TODO move this somewhere else
    ActsAsTenant.with_tenant(nil) do
      Spree::Page.visible.exists?(:slug => ensure_slug_prefix(slug))
    end
  end
end

Spree::Core::Engine.routes.append do
  namespace :admin do
    resources :pages
  end

  constraints(Spree::StaticPage) do
    match '/(*slug)', :to => 'static_content#show', :via => :get, :as => 'static', :defaults => {:slug => '/' }
  end
end
