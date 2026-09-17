# راهنمای عامل‌ها برای «راز بازار بزرگ»

## مسیرهای ابزار

- ریشهٔ پروژه: `E:\Projects\Bazar2`
- فایل اجرایی Godot: `E:\Projects\Godot_v4.7.2\Godot_v4.7.2-stable_win64.exe`
- نسخهٔ کنسولی Godot (برای اجرای خودکار و مشاهدهٔ خطا): `E:\Projects\Godot_v4.7.2\Godot_v4.7.2-stable_win64_console.exe`
- صحنهٔ آغازین: `scenes/main.tscn`
- اسکریپت رابط فعلی: `scripts/main.gd`

برای اعتبارسنجی سریع پروژه از ریشهٔ پروژه اجرا کنید:

```powershell
& 'E:\Projects\Godot_v4.7.2\Godot_v4.7.2-stable_win64_console.exe' --headless --path . --quit-after 3
```

## اسناد لازم پیش از پیاده‌سازی

پیش از تغییر منطق، روایت، رابط یا دارایی‌ها ابتدا این فایل‌ها را بخوانید:

1. `docs/PROJECT-CONTEXT.md` — دامنه، اصول محصول، معماری و وضعیت فعلی.
2. `docs/README.md` — نقشهٔ کامل مستندات.
3. `docs/IMPLEMENTATION-STEPS.md` — گام جاری و ترتیب اجرای کار.
4. `docs/04-art-and-ux.md` و `sources/docs/Style Bible.txt` — قواعد بصری، موبایل، فارسی و RTL.
5. `docs/11-ui-layout-and-rtl.md` — قرارداد لازمِ مختصات، RTL، anchor و z-index؛ هنگام هر تغییر رابط یا هات‌اسپات.
6. `docs/case-01-story.md` — روایت و جزئیات پروندهٔ اول، هنگام کار روی محتوا یا سرنخ‌ها.

## قواعد پروژه

- بازی با Godot 4.x و GDScript ساخته می‌شود؛ هدف اصلی Android، افقی، آفلاین و تک‌نفره است.
- تمام متن‌های نمایشی فارسی و راست‌چین باشند؛ متن یا UI داخل تصویر پس‌زمینه قرار نگیرد.
- دارایی‌ها و دادهٔ پرونده از منطق جدا بمانند. دادهٔ فعلی پرونده در `data/cases/bazaar_001.json` است.
- برای تغییر تصویر یا نقطهٔ لمسِ حجره، پس‌زمینهٔ مرجع فعلی `sources/pics/s1.png` و توضیح صحنه `sources/docs/Scene 01.txt` است.
- برای هر کنترلِ جای‌گذاری‌شده، قرارداد `docs/11-ui-layout-and-rtl.md` را رعایت کنید: بوم و مختصات LTR هستند و RTL فقط برای متن اعمال می‌شود.
- پس از هر تغییر GDScript، اجرای headless بالا را انجام دهید و خروجی خطا را بررسی کنید.
