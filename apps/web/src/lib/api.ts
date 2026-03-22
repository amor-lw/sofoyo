const runtimeEnv = typeof process !== 'undefined' ? process.env : {};
const STRAPI_URL = (runtimeEnv.STRAPI_URL || import.meta.env.STRAPI_URL || 'http://localhost:1337').replace(/\/$/, '');
const STRAPI_PUBLIC_URL = (runtimeEnv.PUBLIC_STRAPI_URL || import.meta.env.PUBLIC_STRAPI_URL || 'http://localhost:1337').replace(
  /\/$/,
  ''
);
const STRAPI_API_TOKEN = runtimeEnv.STRAPI_API_TOKEN || import.meta.env.STRAPI_API_TOKEN || '';
export const LEGACY_ASSET_PREFIX = import.meta.env.PUBLIC_LEGACY_ASSET_PREFIX || '/legacy-assets';

type StrapiCollectionResponse<T> = {
  data: T[];
  meta?: {
    pagination?: {
      total: number;
      page: number;
      pageSize: number;
      pageCount: number;
    };
  };
};

type StrapiSingleResponse<T> = {
  data: T | null;
  meta?: Record<string, unknown>;
};

export type Seo = {
  title?: string;
  description?: string;
};

export type MediaAsset = {
  id: number;
  name?: string;
  alternativeText?: string;
  url: string;
};

export type ProductCategory = {
  id: number;
  documentId?: string;
  name: string;
  slug: string;
  legacyClassId?: number;
};

export type Product = {
  id: number;
  documentId?: string;
  legacyId?: number;
  title: string;
  slug: string;
  sortOrder?: number;
  isFeatured?: boolean;
  code?: string;
  summary?: string;
  content?: string;
  legacyCoverPath?: string;
  cover?: MediaAsset | null;
  hits?: number;
  publishedAtLegacy?: string;
  specNl?: string;
  specWg?: string;
  specXj?: string;
  specKg?: string;
  specCh?: string;
  seo?: Seo;
  category?: ProductCategory | null;
};

export type NewsCategory = {
  id: number;
  name: string;
  slug: string;
  legacyClassId: number;
};

export type NewsItem = {
  id: number;
  title: string;
  slug: string;
  subtitle?: string;
  content?: string;
  legacyCoverPath?: string;
  hits?: number;
  isFeatured?: boolean;
  publishedAtLegacy?: string;
  seo?: Seo;
  category?: NewsCategory | null;
};

export type SitePage = {
  id: number;
  key: string;
  title: string;
  slug: string;
  heroImage?: string;
  gallery?: MediaAsset[];
  content?: string;
  seo?: Seo;
};

export type SiteConfig = {
  id?: number;
  siteName: string;
  heroTitle?: string;
  heroSubtitle?: string;
  homepageAbout?: string;
  footerText?: string;
  contactEmail?: string;
  contactPhone?: string;
  fax?: string;
  postcode?: string;
  address?: string;
  seo?: Seo;
};

function headers() {
  return STRAPI_API_TOKEN
    ? {
        Authorization: `Bearer ${STRAPI_API_TOKEN}`
      }
    : {};
}

async function request<T>(endpoint: string): Promise<T | null> {
  try {
    const response = await fetch(`${STRAPI_URL}${endpoint}`, {
      headers: {
        ...headers()
      }
    });

    if (!response.ok) {
      return null;
    }

    return (await response.json()) as T;
  } catch {
    return null;
  }
}

function withImage(path?: string) {
  if (!path) return '';
  if (path.startsWith('http')) return path;
  return path.startsWith('/') ? path : `${LEGACY_ASSET_PREFIX}/${path}`;
}

export function resolveImage(path?: string) {
  return withImage(path);
}

export function resolveProductImage(product?: Pick<Product, 'cover' | 'legacyCoverPath'> | null) {
  if (!product) return '';
  if (product.cover?.url) {
    return resolveMediaUrl(product.cover.url);
  }
  return resolveImage(product.legacyCoverPath);
}

export function resolveMediaUrl(path?: string) {
  if (!path) return '';
  if (path.startsWith('http://cms:1337') || path.startsWith('https://cms:1337')) {
    return `${STRAPI_PUBLIC_URL}${new URL(path).pathname}`;
  }
  if (path.startsWith(STRAPI_URL)) {
    return `${STRAPI_PUBLIC_URL}${path.slice(STRAPI_URL.length)}`;
  }
  if (path.startsWith('http')) return path;
  if (path.startsWith('/uploads/')) {
    return `${STRAPI_PUBLIC_URL}${path}`;
  }
  return `${STRAPI_URL}${path.startsWith('/') ? path : `/${path}`}`;
}

export function extractExcerpt(html?: string, fallback = '', maxLength = 110) {
  const plain = String(html || '')
    .replace(/<br\s*\/?>/gi, ' ')
    .replace(/<[^>]+>/g, ' ')
    .replace(/&nbsp;/gi, ' ')
    .replace(/&#34;/g, '"')
    .replace(/&ldquo;|&rdquo;/g, '"')
    .replace(/&lsquo;|&rsquo;/g, "'")
    .replace(/&hellip;/g, '...')
    .replace(/&amp;/g, '&')
    .replace(/\s+/g, ' ')
    .trim();

  const source = plain || fallback.trim();
  if (!source) return '旧站新闻内容迁移后会在这里持续维护。';
  if (source.length <= maxLength) return source;
  return `${source.slice(0, maxLength).trim()}...`;
}

export async function getSiteConfig(): Promise<SiteConfig> {
  const response = await request<StrapiSingleResponse<SiteConfig>>('/api/site-config?populate=*');
  return (
    response?.data || {
      siteName: 'sofoyo',
      heroTitle: 'sofoyo 新官网',
      heroSubtitle: 'CMS 尚未导入数据，当前展示的是默认文案。',
      homepageAbout: '完成 Strapi 导入后，这里会显示旧站迁移过来的品牌介绍。',
      footerText: 'sofoyo'
    }
  );
}

export async function getProducts(): Promise<Product[]> {
  const response = await request<StrapiCollectionResponse<Product>>(
    '/api/products?populate[0]=category&populate[1]=cover&sort[0]=category.sortOrder:asc&sort[1]=sortOrder:asc&sort[2]=title:asc&pagination[pageSize]=200'
  );
  return response?.data || [];
}

export async function getProductBySlug(slug: string): Promise<Product | null> {
  const response = await request<StrapiCollectionResponse<Product>>(
    `/api/products?populate[0]=category&populate[1]=cover&filters[slug][$eq]=${encodeURIComponent(slug)}`
  );
  return response?.data?.[0] || null;
}

export async function getProductCategories(): Promise<ProductCategory[]> {
  const response = await request<StrapiCollectionResponse<ProductCategory>>(
    '/api/product-categories?sort[0]=sortOrder:asc&pagination[pageSize]=100'
  );
  return response?.data || [];
}

export async function getNews(): Promise<NewsItem[]> {
  const response = await request<StrapiCollectionResponse<NewsItem>>(
    '/api/news-items?populate=category&sort[0]=publishedAtLegacy:desc&pagination[pageSize]=100'
  );
  return response?.data || [];
}

export async function getNewsBySlug(slug: string): Promise<NewsItem | null> {
  const response = await request<StrapiCollectionResponse<NewsItem>>(
    `/api/news-items?populate=category&filters[slug][$eq]=${encodeURIComponent(slug)}`
  );
  return response?.data?.[0] || null;
}

export async function getSitePageBySlug(slug: string): Promise<SitePage | null> {
  const response = await request<StrapiCollectionResponse<SitePage>>(
    `/api/site-pages?filters[slug][$eq]=${encodeURIComponent(slug)}&populate=gallery&pagination[pageSize]=1`
  );
  return response?.data?.[0] || null;
}

export async function getSitePages(): Promise<SitePage[]> {
  const response = await request<StrapiCollectionResponse<SitePage>>('/api/site-pages?populate=gallery&pagination[pageSize]=100');
  return response?.data || [];
}
