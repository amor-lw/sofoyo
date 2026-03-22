export type NavItem = {
  label: string;
  href: string;
  children?: NavItem[];
};

export type ProductNavItem = {
  label: string;
  href: string;
  slug: string;
};

export const aboutNav: NavItem[] = [
  { label: '企业简介', href: '/pages/about' },
  { label: '企业荣誉', href: '/pages/honor' },
  { label: '企业文化', href: '/pages/culture' },
  { label: '生产流程', href: '/pages/workshop' },
  { label: '海外投资', href: '/pages/history' }
];

export const serviceNav: NavItem[] = [
  { label: '营销网络', href: '/pages/service' },
  { label: '招商加盟', href: '/pages/service-join' },
  { label: '施工方法', href: '/pages/service-method' },
  { label: '屋瓦常识', href: '/pages/service-knowledge' },
  { label: '工程案例', href: '/pages/service-projects' }
];

export const newsNav: NavItem[] = [
  { label: '企业新闻', href: '/news?category=company-news' },
  { label: '行业动态', href: '/news?category=industry-updates' },
  { label: '媒体报道', href: '/news?category=media-coverage' }
];

export const mainNav: NavItem[] = [
  { label: '首页', href: '/' },
  { label: '关于我们', href: '/pages/about', children: aboutNav },
  { label: '产品中心', href: '/products' },
  { label: '新闻资讯', href: '/news', children: newsNav },
  { label: '客户服务', href: '/pages/service', children: serviceNav },
  { label: '联系我们', href: '/contact' }
];

export const pageNav: NavItem[] = [
  ...aboutNav,
  ...serviceNav
];

export function getPageSectionNav(slug: string): NavItem[] {
  if (aboutNav.some((item) => item.href === `/pages/${slug}`)) {
    return aboutNav;
  }

  if (serviceNav.some((item) => item.href === `/pages/${slug}`)) {
    return serviceNav;
  }

  return [];
}

export function buildProductSectionNav(
  categories: Array<{ name: string; slug: string }>
): ProductNavItem[] {
  return [
    { label: '全部产品', href: '/products', slug: '' },
    ...categories.map((category) => ({
      label: category.name,
      href: `/products?category=${encodeURIComponent(category.slug)}`,
      slug: category.slug
    }))
  ];
}
