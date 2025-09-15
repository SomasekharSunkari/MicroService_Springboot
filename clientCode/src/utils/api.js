export const API_BASE = 'http://public-ms-balancer-992743410.us-east-1.elb.amazonaws.com';

export async function apiFetch(path, { method = 'GET', headers = {}, body } = {}) {
  const token = localStorage.getItem('jwt_token');
  const finalHeaders = {
    'Content-Type': 'application/json',
    ...headers,
  };
  if (token) {
    finalHeaders['Authorization'] = `Bearer ${token}`;
  }
  const res = await fetch(`${API_BASE}${path}`, {
    method,
    headers: finalHeaders,
    body: body ? JSON.stringify(body) : undefined,
  });
  const isJson = res.headers.get('content-type')?.includes('application/json');
  const data = isJson ? await res.json() : await res.text();
  if (!res.ok) {
    const message = (isJson && data && (data.message || data.error)) || res.statusText;
    throw new Error(message || 'Request failed');
  }
  return data;
}


