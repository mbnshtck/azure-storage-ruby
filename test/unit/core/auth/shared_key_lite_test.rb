#-------------------------------------------------------------------------
# # Copyright (c) Microsoft and contributors. All rights reserved.
#
# The MIT License(MIT)

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files(the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions :

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#--------------------------------------------------------------------------
require 'test_helper'
require 'azure/core/auth/shared_key_lite'

describe Azure::Core::Auth::SharedKeyLite do
  subject { Azure::Core::Auth::SharedKeyLite.new 'account-name', 'YWNjZXNzLWtleQ==' }
  
  let(:verb) { 'POST' }
  let(:uri) { URI.parse 'http://dummy.uri/resource' }
  let(:headers) do
    {
      'Content-MD5' => 'foo',
      'Content-Type' => 'foo',
      'Date' => 'foo'
    }
  end
  let(:headers_without_date) { 
    headers_without_date = headers.clone
    headers_without_date.delete 'Date'
    headers_without_date
  }
  
  describe 'sign' do
    it 'creates a signature from the provided HTTP method, uri, and reduced set of standard headers' do
      subject.sign(verb, uri, headers).must_equal 'account-name:vVFnj/+27JFABZgpt5H8g/JVU2HuWFnjv5aeUIxQvBE='
    end

    it 'ignores standard headers other than Content-MD5, Content-Type, and Date' do
      subject.sign(verb, uri, headers.merge({'Content-Encoding' => 'foo'})).must_equal 'account-name:vVFnj/+27JFABZgpt5H8g/JVU2HuWFnjv5aeUIxQvBE='
    end

    it 'throws IndexError when there is no Date header' do
      assert_raises IndexError do
        subject.sign(verb, uri, headers_without_date)
      end
    end
  end
end
