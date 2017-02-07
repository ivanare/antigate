# Wrapper for [Antigate][1] API
Gem recognizes CAPTCHA by means Antigate.

[Registration Antigate account][2]

## Install
### Gemfile Install
    gem 'antigate', :github => 'SeNaP/antigate'
### Local Install
    git clone https://github.com/SeNaP/antigate.git
    cd antigate && gem build antigate
    sudo gem install antigate.gem
## Usage
### Recognize captcha
    captcha = Antigate.wrapper(KEY)
    captcha.phrase = 0 or 1 (0 default, 1 marks that at captcha 2-4 words)
    captcha.regsense = 0 or 1 (0 default, 1 marks that text captcha is case sensitive)
    captcha.numeric = 0 or 1 or 2 (0 default, 1 marks that text captcha consists only of numbers, 2 marks that on captcha no digit)
    captcha.calc = 0 or 1 (0 default, 1 marks that digit  on captcha should be folded)
    captcha.min_len = 0..20 (0 default, minimum length text captcha)
    captcha.max_len = 0..20 (0 - unlimited, maximum length text captcha)
    recognized = captcha.recognize(URL, EXT)
    puts recognized[0] # ID recognized CAPTCHA
    puts recognized[1] # Text CAPTCHA

#### From remote file
    captcha = Antigate.wrapper('660aaf58948bae3fa81362ef71b9ebcc')
    captcha.phrase = 1
    recognized = captcha.recognize('http://www.google.com/recaptcha/api/image?c=03AHJ_Vuu-Kun_wMo4M8JiWA87K6awfoiUxJCUF9KkQq3tCfyxjYELhHcsIJrcJ_qgqIQQsBw5vWAkpHBqP4VEHv1nwtoAnD5uZvwzHknOFyID4OrX0_6q8QXQ5TwkRn7qBxdt3QdX6D8NvPcFHFHzmEhu1yCJJQfTwQ', 'jpg')
    puts recognized[1]
#### From local file
    captcha = Antigate.wrapper('660aaf58948bae3fa81362ef71b9ebcc')
    captcha.phrase = 1
    recognized = captcha.recognize('captcha', 'jpg')
    puts recognized[1]
### Get balance
    puts Antigate.balance(KEY)

#### Example
    puts Antigate.balance('660aaf58948bae3fa81362ef71b9ebcc')

[1]: http://antigate.com/
[2]: http://antigate.com/index.php?action=regscreen
