from test import cases as case
from test import fixtures as data

from django.test import RequestFactory
from django.core.management import call_command

from vendors.models import Vendor
from vendors.views import VendorView


def make_view(view, request, *args, **kwargs):
    view.request = request
    view.args = args
    view.kwargs = kwargs
    return view


class VendorLoadTest(case.BaseTestCase):
    
    fixtures = data.get_category_fixtures()

    
    def test_load(self):
        call_command('load_vendors', vpp=1)
        call_command('load_sam')
    
    
    def test_sam_expiration_not_null(self):
        null_vendors = Vendor.objects.filter(sam_expiration_date=None).count()
        self.assertEqual(null_vendors, 0)


    def test_cm_not_null(self):
        for vendor in Vendor.objects.all():
            self.assertNotEqual(vendor.managers.filter(type='CM').first().phones().count(), 0)


    def test_pm_not_null(self):
        for vendor in Vendor.objects.all():
            self.assertNotEqual(vendor.managers.filter(type='PM').first().phones().count(), 0)


class VendorViewTest(case.BaseTestCase):
    def test_has_capability_statement_false(self):
        request = RequestFactory().get('/vendor/0000?vehicle=oasis_sb')
        view = VendorView(template_name='vendor.html')
        view = make_view(view, request)
        context = view.get_context_data(vendor_duns='0000')
        self.assertFalse(context['has_capability_statement'])

    def test_has_capability_statement(self):
        request = RequestFactory().get('/vendor/626979228?vehicle=oasis_sb')
        view = VendorView(template_name='vendor.html')
        view = make_view(view, request)
        context = view.get_context_data(vendor_duns='626979228')
        self.assertTrue(context['has_capability_statement'])
        self.assertEqual(context['capability_statement_url'],
                         'discovery_site/capability_statements/oasis_sb/626979228.pdf')
