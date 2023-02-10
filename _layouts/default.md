<!DOCTYPE html>
<html lang="{{ page.language | default: site.language | default: 'en' }}">

    {% include head.html %}

    <body>    
        {% include views/header.html %}

        {{ content }}

        {% include views/footer.html %}
    </body>

</html>