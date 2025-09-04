export const generateTempOrderReference = () => {
    const date = new Date();
    const dateStr = date.toISOString().slice(0,10).replace(/-/g,'');
    const randomStr = Math.floor(Math.random() * 10000).toString().padStart(4, '0');
    return `TMP-${dateStr}-${randomStr}`;
};